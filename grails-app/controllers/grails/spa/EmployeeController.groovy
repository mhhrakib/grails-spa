package grails.spa

import grails.converters.JSON

class EmployeeController {

    def index() {
        redirect(action: 'list')
    }

    def list() {
        def employees = Employee.list()
        render employees as JSON
    }

    def save() {
        def employee = new Employee(params)
        if (employee.save()) {
            render 'success'
        } else {
            render status: 400, contentType: 'application/json', {
                errors = employee.errors
            }
        }
    }

    def update() {
        def employee = Employee.get(params.id)
        if (employee) {
            employee.properties = params
            if (employee.save()) {
                render 'success'
            } else {
                render status: 400, contentType: 'application/json', {
                    errors = employee.errors
                }
            }
        } else {
            render 'not found'
        }
    }

    def delete() {
        def employee = Employee.get(params.id)
        if (employee) {
            employee.delete()
            render 'success'
        } else {
            render 'not found'
        }
    }
}
