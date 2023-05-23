package grails.spa

class FileController {

    static allowedMethods = [download: "GET", delete: "DELETE"]

    def fileService

    def download(Long id) {
        File file = fileService.getFileById(id)
        if (file) {
            byte[] fileContent = fileService.downloadFile(file.path)
            if (fileContent) {
                response.setContentType(file.contentType)
                response.setHeader('Content-Disposition', "attachment; filename=\"${file.name.substring(file.name.indexOf("_") + 1)}\"")
                response.getOutputStream().write(fileContent)
                response.getOutputStream().flush()
            } else {
                flash.message = 'File not found.'
                redirect(controller: 'employee', action: 'list')
            }
        } else {
            flash.message = 'File not found.'
            redirect(controller: 'employee', action: 'list')
        }
    }


    def delete() {
        boolean deleted = fileService.deleteFile(params.id)
        if (deleted) {
            flash.message = 'File deleted successfully.'
        } else {
            flash.message = 'Failed to delete the file.'
        }
        redirect(controller: 'employee', action: 'list')
    }
}
