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

        String newFileName = UUID.randomUUID().toString() + "_" + originalFileName

        String uploadDirectory = Holders.grailsApplication.config.myapp.upload.directory

        Path uploadPath = Paths.get(uploadDirectory)
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath)
        }

        Path destinationPath = Paths.get(uploadDirectory, newFileName)
        Files.copy(file.getInputStream(), destinationPath, StandardCopyOption.REPLACE_EXISTING)

        File savedFile = new File(path: destinationPath.toString(), name: newFileName,
                type: type, extension: fileExtension, size: fileSize, contentType: contentType)

        return savedFile
    }

    def getFileById(fileId) {
        return File.get(fileId)
    }

    byte[] downloadFile(filePath) {
        Path file = Paths.get(filePath)
        if (Files.exists(file)) {
            return Files.readAllBytes(file)
        }
        return null
    }

    boolean deleteFile(fileId) {
        def file = File.get(fileId)
        if (file) {
            Path filePath = Paths.get(file.path)
            if (Files.exists(filePath)) {
                Files.delete(filePath)
                file.delete()
                return true
            }
        }
        return false
    }
}
