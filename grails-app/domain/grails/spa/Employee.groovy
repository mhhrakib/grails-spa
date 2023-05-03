package grails.spa

class Employee {

    String firstName
    String lastName
    String email

    static constraints = {
        firstName nullable: false, blank: false, size: 2..50, message: "The first name is invalid. It must be between 2 and 50 characters long."
        lastName nullable: false, blank: false, size: 2..50, message: "The last name  is invalid. It must be between 2 and 50 characters long."
        email nullable: false, blank: false, email: true, unique: true, message: "The email address is already in use."
    }

}

