package grails.spa

class EmployeeService {

    def get(id){
        Employee.get(id)
    }

    def list(params) {
        Employee.list(params)
    }

    def save(Employee employee){
        if(employee.validate()) {
            employee.save(flush:true)
        } else {
            return null
        }
    }

    def delete(id){
        Employee.get(id).delete()
    }
}
