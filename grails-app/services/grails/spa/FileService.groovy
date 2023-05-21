package grails.spa

import grails.util.Holders
import org.springframework.web.multipart.MultipartFile

import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.StandardCopyOption

class FileService {

    def save(MultipartFile file, String type) {
        String originalFileName = file.getOriginalFilename()
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.') + 1)
        String contentType = file.getContentType()
        long fileSize = file.getSize()

        // Generate a unique filename for the file
        String newFileName = UUID.randomUUID().toString() + "_" + originalFileName

        // Get the upload directory from the configuration
        String uploadDirectory = Holders.grailsApplication.config.myapp.upload.directory

        // Create the upload directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDirectory)
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath)
        }

        // Save the file to disk
        Path destinationPath = Paths.get(uploadDirectory, newFileName)
        Files.copy(file.getInputStream(), destinationPath, StandardCopyOption.REPLACE_EXISTING)

        // Create a new File object and save it to the database
        File savedFile = new File(path: destinationPath.toString(), name: newFileName,
                type: type, extension: fileExtension, size: fileSize, contentType: contentType)
        return savedFile.save(flush: true)
    }

    def download(String fileName) {
        File file = File.findByName(fileName)
        if (file) {
            String filePath = file.path

            // Set the content type of the response based on the file type
            response.contentType = file.contentType

            // Write the file to the response output stream
            response.outputStream << new File(filePath).bytes

            // Return null to prevent the view from being rendered
            return null
        } else {
            throw new FileNotFoundException("File not found: ${fileName}")
        }
    }
}
