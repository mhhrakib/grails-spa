package grails.spa

class File {

    String name
    String type // type of the file e.g. birth certificate, nid, etc.
    String contentType
    String extension
    long size
    String path
    Date createdAt

    static belongsTo = [employee: Employee]

    static constraints = {
        name(nullable: false)
        type(nullable: false)
        size(nullable: false)
        path(nullable: false)
        contentType(nullable: false)
        extension(nullable: false)
    }

}
