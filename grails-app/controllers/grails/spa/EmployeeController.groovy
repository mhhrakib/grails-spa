package grails.spa

import grails.converters.JSON

class EmployeeController {
    def employeeService

    def index() {
        redirect(action: 'list')
    }

    def list() {
        def result = employeeService.listEmployees(params)
        render result as JSON
    }

    def save() {
        def saveResult = employeeService.saveEmployee(params)
        if (saveResult == 'success') {
            render 'success'
        } else {
            render status: 400, contentType: 'application/json', {
                errors = saveResult
            }
        }
    }

    def update() {
        def updateResult = employeeService.updateEmployee(params) // Call the updateEmployee method on the injected service
        if (updateResult == 'success') {
            render 'success'
        } else if(updateResult == 'not found') {
            render status: 404, 'not found'
        } else {
            render status: 400, contentType: 'application/json', {
                errors = updateResult
            }
        }
    }

    def delete() {
        return employeeService.deleteEmployee(params)
    }
}
