package grails.spa

class EmployeeService {

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
                totalCount : totalCount,
                currentPage: page,
                pageSize   : pageSize,
                totalPages : Math.ceil(filteredCount / pageSize),
                employees  : employees,
                filteredCount: filteredCount
        ]

        return result
    }

    def saveEmployee(params) {
        def employee = new Employee(params)
        if (employee.save()) {
            return 'success'
        } else {
            return [errors: employee.errors]
        }
    }

    def updateEmployee(params) {
        def employee = Employee.get(params.id)
        if (employee) {
            employee.properties = params
            if (employee.save()) {
                return 'success'
            } else {
                return [errors: employee.errors]
            }
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
