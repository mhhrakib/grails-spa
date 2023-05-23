<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Employee</title>
</head>

<body>
<div class="container">
    <h3>Employee</h3>
    <br>

    <form id="employeeForm" action="${createLink(controller: 'employee', action: 'save')}" method="post">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter first name"
                           minlength="2" maxlength="50"/>
                    <span class="error text-danger text-sm" id="firstNameError"></span>
                    <br>
                </div>
            </div>

            <div class="col-md-6">
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter last name"
                           minlength="2" maxlength="50"/>
                    <span class="error text-danger text-sm" id="lastNameError"></span>
                    <br>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter email"/>
                    <span class="error text-danger text-sm" id="emailError"></span>
                    <br>
                </div>
            </div>

            <div class="col-md-6">
                <div class="form-group">
                    <label for="birthDate">Birth Date</label>
                    <input type="date" class="form-control" id="birthDate" name="birthDate" placeholder="yyyy-mm-dd"
                           required/>
                    <span class="error text-danger text-sm" id="birthDateError"></span>
                    <br>
                </div>
            </div>
        </div>

        <div id="fileInputs">
            <div class="row" id="fileInput_0">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="title_0">Document Type</label><br>
                        <input type="text" class="form-control" name="title_0" id="title_0" placeholder="Title"/>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="form-group">
                        <label for="file_0">File</label><br>
                        <input type="file" class="form-control" name="file_0" id="file_0"/>
                    </div>
                </div>

                <div class="col-md-1">
                    <br>
                    <button type="button" class="btn btn-primary" id="addFileBtn">+</button>
                </div>
            </div>
        </div>
        <br>

        <button type="button" class="btn btn-primary" id="submitBtn">Save</button>

    </form>

    <br>

    <h3>Employee List</h3>

    <div class="row mb-3">
        <div class="col-sm-6">
            <input type="text" class="form-control" id="searchInput" placeholder="Search...">
        </div>

        <div class="col-sm-3">

        </div>

        <div class="col-sm-3">
            <select id="pageSizeSelect" class="form-select">
                <option value="5">5 per page</option>
                <option value="10">10 per page</option>
                <option value="25">25 per page</option>
                <option value="50">50 per page</option>
            </select>
        </div>
    </div>
    <table class="table" id="employeeTable">
        <thead>
        <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Birth Date</th>
            <th>Files</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <div class="row mb-3">
        <div class="col-sm-6" id="paginationInfo">
            Showing <span id="startEntry"></span> to <span id="endEntry"></span> of <span
                id="totalEntries"></span> entries
        </div>

        <div class="col-sm-6">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-end" id="paginationLinks">
                </ul>
            </nav>
        </div>
    </div>
</div>

<div class="modal modal-lg fade" id="fileDetailsModal" tabindex="-1" role="dialog" aria-labelledby="fileModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="fileModalLabel">File Details of Employee <span id="xyz"></span><span
                        id="empId"></span></h5>
            </div>

            <div class="modal-body">
                <table class="table table-striped" id="fileDetailsTable">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Content Type</th>
                        <th>Extension</th>
                        <th>Size</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id="fileDetailsBody">
                    </tbody>
                </table>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="http://transport.kgdcl.gov.bd/adminlte/plugins/jquery-validation/jquery.validate.min.js"></script>
<script src="http://transport.kgdcl.gov.bd/adminlte/plugins/jquery-validation/additional-methods.min.js"></script>
<script>
    function displayErrors(errors) {
        for (let i = 0; i < errors.length; i++) {
            var error = errors[i];
            var fieldName = error.field;
            var errorMessage = error.message;
            var errorSpan = document.getElementById(fieldName + "Error");
            errorSpan.innerHTML = errorMessage;
        }
    }

    function clearErrorOnFocus(field) {
        var errorSpan = document.getElementById(field + "Error");
        var inputField = document.getElementById(field);

        inputField.addEventListener("focus", function () {
            errorSpan.innerHTML = "";
        });
    }

    clearErrorOnFocus("firstName");
    clearErrorOnFocus("lastName");
    clearErrorOnFocus("email");

    function submitForm(action, url) {
        var form = $('#employeeForm');
        var formData = new FormData(form[0]);
        if(form.valid()) {
            if (confirm('Are you sure you want to ' + action + ' this employee?')) {
                $.ajax({
                    type: "POST",
                    url: url,
                    data: formData,
                    enctype: 'multipart/form-data',
                    processData: false,
                    contentType: false,
                    success: function (data) {
                        alert('Employee ' + action + 'd successfully');
                        form.trigger('reset');
                        $('.error').text('');
                        refreshTable();
                    },
                    error: function (xhr, status, error) {
                        var errors = $.parseJSON(xhr.responseText);
                        displayErrors(errors.errors);
                    }
                });
            }
        } else {
            console.log("test");
            form.find(":input").each(function() {
                console.log(this);
                form.validate().element($(this));
            });
        }
    }
    $(document).ready(function () {
        var fileCount = 1;

        $('#addFileBtn').click(function (e) {
            var fileId = 'file_' + fileCount;
            var titleId = 'title_' + fileCount;
            var fileInputId = 'fileInput_' + fileCount;
            var fileInputRow = 'fileInput_' + fileCount;
            console.log(fileCount, fileInputId, fileId, titleId);

            e.preventDefault();

            var inputHtml = '<div class="row" id="fileInput_' + fileCount + '">' +
                '<div class="col-md-6 form-group">' +
                '<label for="' + titleId + '">Document Type</label>' +
                '<input type="text" required class="form-control" name="' + titleId + '" id="' + titleId + '" placeholder="Title"/>' +
                '</div>' +
                '<div class="col-md-5 form-group">' +
                '<label for="' + fileId + '">File</label><br>' +
                '<input type="file" required class="form-control" name="' + fileId + '" id="' + fileId + '"/>' +
                '</div>' +
                '<div class="col-md-1"> <br><button class="removeFileBtn btn btn-danger" data-file-id="' + fileCount + '">-</button></div>' +
                '</div>';
            $('#fileInputs').append(inputHtml);

            fileCount++;
        });

        $("#employeeForm").validate({
            rules: {
                firstName: {
                    required: true,
                    minlength: 2,
                    maxlength: 50
                },
                lastName: {
                    required: true,
                    minlength: 2,
                    maxlength: 50
                },
                email: {
                    required: true,
                    email: true
                }
            },
            messages: {
                firstName: {
                    required: "Please enter your first name",
                    minlength: "First name must be at least 2 characters long",
                    maxlength: "First name cannot be more than 50 characters long"
                },
                lastName: {
                    required: "Please enter your last name",
                    minlength: "Last name must be at least 2 characters long",
                    maxlength: "Last name cannot be more than 50 characters long"
                },
                email: {
                    required: "Please enter email address",
                    email: "Please enter a valid email address"
                }
            },
            errorElement: 'span',
            errorClass: 'text-danger text-sm',
            highlight: function (element) {
                $(element).closest('.form-group').addClass('error');
            },
            unhighlight: function (element) {
                $(element).closest('.form-group').removeClass('error');
            },
            errorPlacement: function (error, element) {
                if (element.attr("name") == "firstName") {
                    error.appendTo($("#firstNameError"));
                } else if (element.attr("name") == "lastName") {
                    error.appendTo($("#lastNameError"));
                } else if (element.attr("name") == "email") {
                    error.appendTo($("#emailError"));
                }
            }
        });


        $(document).on('click', '.removeFileBtn', function (e) {
            e.preventDefault();
            var fileId = $(this).data('file-id');
            console.log(fileId);
            $('#fileInput_' + fileId).remove();
            $('#fileInputRow' + fileId).remove();
        });


        $('#submitBtn').click(function (event) {
            event.preventDefault();
            var url = "${createLink(controller: 'employee', action: 'save')}";
            submitForm('save', url);
        });

        refreshTable();
        $('#search').on('keyup', function () {
            dataTable.search($(this).val()).draw();
        });

        $('#searchInput').on('input', function () {
            refreshTable();
        });

        $('#pageSizeSelect').on('change', function () {
            refreshTable();
        });

        // Handle pagination links
        $('#paginationLinks').on('click', '.page-link', function (event) {
            event.preventDefault();
            var page = $(this).text();
            if (page == "Next") {
                page = parseInt($('#paginationLinks .active').text()) + 1;
            } else if (page == "Prev") {
                page = parseInt($('#paginationLinks .active').text()) - 1;
            }
            refreshTable(page);
        });
    });


    $(document).on('click', '#fileDetailsModal .btn-delete', function (event) {
        event.preventDefault();
        console.log("clicked");
        var fileId = $(this).attr('data-file-id'); // Retrieve the file ID from the data attribute
        console.log('file id ' + fileId);
        if (confirm("Are you sure you want to delete this file?")) {
            deleteFile(fileId);
            console.log($("#empId").text());
            populateFileTable($("#empId").text());
        }
    });

    function refreshTable(page = 1) {
        var table = $('#employeeTable');
        var search = $('#searchInput').val();
        var pageSize = $('#pageSizeSelect').val() || 5;
        var url = "${createLink(controller: 'employee', action: 'list')}";
        $.ajax({
            type: "GET",
            url: url,
            data: {page: page, pageSize: pageSize, search: search},
            success: function (data) {
                console.log(data)
                table.find('tbody').empty();
                $(data.employees).each(function (index, element) {
                    var row = $('<tr>').appendTo(table.find('tbody'));
                    $('<td>').text(element.id).appendTo(row);
                    $('<td>').text(element.firstName).appendTo(row);
                    $('<td>').text(element.lastName).appendTo(row);
                    $('<td>').text(element.email).appendTo(row);
                    let formattedDate = new Date(element.birthDate).toLocaleDateString('en-US', {
                        day: '2-digit',
                        month: 'short',
                        year: 'numeric'
                    });

                    $('<td>').text(formattedDate).appendTo(row);
                    var fileViewDiv = $('<div>').addClass('btn-group').appendTo($('<td>').appendTo(row));
                    var viewBtn = $('<button>').text('View').addClass('btn btn-info').appendTo(fileViewDiv);
                    viewBtn.click(function () {
                        showFiles(element.id);
                    });


                    var actionsDiv = $('<div>').addClass('btn-group').appendTo($('<td>').appendTo(row));

                    var editBtn = $('<button>').text('Edit').addClass('btn btn-info').appendTo(actionsDiv);
                    editBtn.click(function () {
                        editEmployee(element.id, element.firstName, element.lastName, element.email, element.birthDate);
                    });
                    var deleteBtn = $('<button>').text('Delete').addClass('btn btn-danger').appendTo(actionsDiv);
                    deleteBtn.click(function () {
                        deleteEmployee(element.id);
                    });
                });
                // Update pagination links
                var links = $('#paginationLinks');
                links.empty();
                $('<li>').addClass('page-item').toggleClass('disabled', data.currentPage === 1).append($('<a>').addClass('page-link').attr('href', '#').text("Prev"))
                    .appendTo(links);
                for (var i = 1; i <= data.totalPages; i++) {
                    $('<li>').addClass('page-item').toggleClass('active', i === data.currentPage).append($('<a>').addClass('page-link').attr('href', '#').text(i)).appendTo(links);
                }
                $('<li>').addClass('page-item').toggleClass('disabled', data.currentPage === data.totalPages).append($('<a>').addClass('page-link')
                    .attr('href', '#').text("Next")).appendTo(links);

                // Display pagination information
                var filteredCount = data.filteredCount;
                var totalCount = data.totalCount;
                var start = ((data.currentPage - 1) * pageSize) + (data.totalPages == 0 ? 0 : 1);
                var end = Math.min(start + data.pageSize - 1, filteredCount);
                var info = 'Showing ' + start + ' to ' + end + ' of ' + filteredCount + ' entries (filtered from ' + totalCount + ' total entries)';
                $('#paginationInfo').text(info);

            },
            error: function (xhr, status, error) {
                alert(xhr.responseText);
            }
        });
    }

    function populateFileTable(employeeId) {
        var url = "${createLink(controller: 'employee', action: 'getFiles')}" + '/' + employeeId;
        var filesTable = $('#fileDetailsTable');
        $('#xyz').text("#");
        $('#empId').text(employeeId);
        $.ajax({
            type: "GET",
            url: url,
            success: function (data) {
                filesTable.find('tbody').empty();
                $(data).each(function (index, file) {
                    var fileRow = $('<tr>').appendTo(filesTable.find('tbody'));
                    $('<td>').text(file.name.substring(file.name.indexOf("_") + 1)).appendTo(fileRow);
                    $('<td>').text(file.type).appendTo(fileRow);
                    $('<td>').text(file.contentType).appendTo(fileRow);
                    $('<td>').text(file.extension).appendTo(fileRow);
                    $('<td>').text(file.size).appendTo(fileRow);

                    var buttonGroup = $('<div>').addClass('btn-group').appendTo(fileRow);
                    var downloadBtn = $('<button>').addClass('btn btn-primary').appendTo(buttonGroup);
                    var downloadIcon = $('<i>').addClass('fa fa-download').appendTo(downloadBtn);
                    downloadBtn.click(function () {
                        window.location.href = "${createLink(controller: 'file', action: 'download')}/" + file.id;
                    });

                    var deleteBtn = $('<button>').addClass('btn btn-danger btn-delete').appendTo(buttonGroup);
                    var deleteIcon = $('<i>').addClass('fa fa-trash').appendTo(deleteBtn);
                    deleteBtn.attr('data-file-id', file.id);
                });

            },
            error: function (xhr, status, error) {
                console.log(error);
            }
        });
    }

    function showFiles(employeeId) {
        populateFileTable(employeeId);
        $('#fileDetailsModal').modal('show');
    }


    function editEmployee(id, firstName, lastName, email, birthDate) {
        console.log("BirthDate: " + birthDate);
        $('#id').val(id);
        $('#firstName').val(firstName);
        $('#lastName').val(lastName);
        $('#email').val(email);
        $('#birthDate').val(new Date(birthDate).toISOString().split('T')[0]);

        $('#submitBtn').text('Update').unbind('click').click(function (event) {
            event.preventDefault();
            var form = $('#employeeForm');
            var url = "${createLink(controller: 'employee', action: 'update')}" + '/' + id;
            submitForm('update', url);
        });
    }

    function deleteEmployee(id) {
        if (confirm('Are you sure you want to delete this employee?')) {
            var url = "${createLink(controller: 'employee', action: 'delete')}" + '/' + id;
            $.ajax({
                type: "DELETE",
                url: url,
                success: function (data) {
                    alert('Employee deleted successfully');
                    refreshTable();
                },
                error: function (xhr, status, error) {
                    alert(xhr.responseText);
                }
            });
        }
    }

    function deleteFile(fileId) {
        $.ajax({
            url: "${createLink(controller: 'file', action: 'delete')}/" + fileId,
            type: 'DELETE',
            async: false,
            success: function (data) {
                alert("File deletion successful.");
            },
            error: function (xhr, status, error) {
            }
        });
    }
</script>
</body>
</html>