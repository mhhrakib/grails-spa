package grails.spa

import grails.converters.JSON

class EmployeeController {

    static allowedMethods = [index: "GET",list: "GET", delete: "DELETE", save: "POST", update: "POST", getFiles: "GET"]

    def employeeService

    def index() {
        redirect(action: 'list')
    }

    def list() {
        def result = employeeService.listEmployees(params)
        render result as JSON
    }

    def save() {
        def saveResult = employeeService.saveEmployee(params, request)
        if (saveResult == 'success') {
            render 'success'
        } else {
            render status: 400, contentType: 'application/json', {
                errors = saveResult
            }
        }
    }

    def update() {
        def updateResult = employeeService.updateEmployee(params, request)
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
        def res = employeeService.deleteEmployee(params)
        render res
    }

    def getFiles() {
        def res = employeeService.getAllFiles(params)
        if(res == 'not found') {
            render status: 404, 'not found'
        } else {
            render res as JSON
        }
    }
}
