package grails.spa

import org.springframework.web.multipart.MultipartFile

class EmployeeService {

    def fileService

    def listEmployees(params) {
        def page = params.int('page') ?: 1 // default to page 1
        def pageSize = params.int('pageSize') ?: 5 // default to 10 results per page
        def search = params.search ?: ""
        def sortColumn = params.sort ?: "id"
        def sortDirection = params.dir ?: "asc"

        def employees
        def filteredCount

        if (search && search.trim().length() > 0) {
            employees = Employee.createCriteria().list(max: pageSize, offset: (page - 1) * pageSize) {
                or {
                    ilike('firstName', "%${search}%")
                    ilike('lastName', "%${search}%")
                    ilike('email', "%${search}%")
                }
                order(sortColumn, sortDirection.toLowerCase())
            }
            filteredCount = Employee.createCriteria().count {
                or {
                    ilike('firstName', "%${search}%")
                    ilike('lastName', "%${search}%")
                    ilike('email', "%${search}%")
                }
            }
        } else {
            employees = Employee.list(max: pageSize, offset: (page - 1) * pageSize)
            filteredCount = Employee.count()
        }

        def totalCount = Employee.count()
        def result = [
                totalCount   : totalCount,
                currentPage  : page,
                pageSize     : pageSize,
                totalPages   : Math.ceil(filteredCount / pageSize),
                employees    : employees,
                filteredCount: filteredCount
        ]

        return result
    }

    def saveEmployee(params, request) {
        def employee = new Employee(
                firstName: params.firstName,
                lastName: params.lastName,
                email: params.email,
                birthDate: new Date().parse('yyyy-MM-dd', params.birthDate),
        )
        createEmployee(params, request, employee)

        if (employee.save(flush: true)) {
            return 'success'
        } else {
            return employee.errors
        }
    }

    private createEmployee(params, request, employee) {
        List<String> fileKeys = params.keySet().findAll { it.startsWith("file_") }.toList()
        fileKeys.each { fileKey ->
            MultipartFile uploadedFile = request.getFile(fileKey)
            if (uploadedFile.getSize() > 0) {
                String correspondingTitleKey = "title_" + fileKey.substring(5)
                String type = params[correspondingTitleKey]
                def res = fileService.save(uploadedFile, type)
                employee.addToFiles(res)
            } else {
                // File is not present, handle the case
                // ...
            }
        }
    }

    def updateEmployee(params, request) {
        def employee = Employee.get(params.id)
        // incredible fix
        params.birthDate = new Date().parse('yyyy-MM-dd', params.birthDate)
        employee.properties = params
        if (employee) {
            createEmployee(params, request, employee)
            if (employee.save()) {
                return 'success'
            } else {
                return employee.errors
            }
        } else {
            return 'not found'
        }
    }

    def getAllFiles(params) {
        def employee = Employee.get(params.id);
        if (employee) {
            return employee.files
        } else {
            return 'not found'
        }
    }

    def deleteEmployee(params) {
        def employee = Employee.get(params.id)
        if (employee) {
            employee.delete()
            return 'success'
        } else {
            return 'not found'
        }
    }

}
