<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Employee</title>
</head>

<body>
<div class="container">
    <h1>Employee</h1>
    <br>
    <form id="employeeForm" action="${createLink(controller: 'employee', action: 'save')}" method="post">
        <div class="form-group">
            <label for="firstName">First Name</label>
            <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter first name" minlength="2" maxlength="50"/>
            <span class="error text-danger text-sm" id="firstNameError"></span>
            <br>
        </div>

        <div class="form-group">
            <label for="lastName">Last Name</label>
            <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter last name" minlength="2" maxlength="50"/>
            <span class="error text-danger text-sm" id="lastNameError"></span>
            <br>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Enter email"/>
            <span class="error text-danger text-sm" id="emailError"></span>
            <br>
        </div>
        <button type="submit" class="btn btn-primary" id="submitBtn">Save</button>
    </form>

    <br>

    <h1>Employee List</h1>
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
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <div class="row mb-3">
        <div class="col-sm-6" id="paginationInfo">
            Showing <span id="startEntry"></span> to <span id="endEntry"></span> of <span id="totalEntries"></span> entries
        </div>
        <div class="col-sm-6">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-end" id="paginationLinks">
                </ul>
            </nav>
        </div>
    </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
  function displayErrors(errors) {
    // console.log(errors, errors.length);
    for (let i = 0; i < errors.length; i++) {
      var error = errors[i];
      var fieldName = error.field;
      var errorMessage = error.message;
      var errorSpan = document.getElementById(fieldName + "Error");
      errorSpan.innerHTML = errorMessage;
    }
  }

  $(document).ready(function () {
    $('#submitBtn').click(function (event) {
      event.preventDefault();
      var form = $('#employeeForm');
      var url = form.attr('action');
      if (confirm('Are you sure you want to save this employee?')) {
        $.ajax({
          type: "POST",
          url: url,
          data: form.serialize(),
          success: function (data) {
            alert('Employee saved successfully');
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
    });
    refreshTable();
    $('#search').on('keyup', function() {
      dataTable.search($(this).val()).draw();
    });
    $('#searchInput').on('input', function () {
      refreshTable();
    });
    $('#pageSizeSelect').on('change', function() {
      refreshTable();
    });
    // Handle pagination links
    $('#paginationLinks').on('click', '.page-link', function (event) {
      event.preventDefault();
      var page = $(this).text();
      if(page == "Next") {
        page = parseInt($('#paginationLinks .active').text()) + 1;
      } else if(page == "Prev") {
        page = parseInt($('#paginationLinks .active').text()) - 1;
      }
      refreshTable(page);
    });
  });

  function refreshTable(page = 1) {
    var table = $('#employeeTable');
    var search = $('#searchInput').val();
    var pageSize = $('#pageSizeSelect').val() || 5;
    var url = "${createLink(controller: 'employee', action: 'list')}";
    $.ajax({
      type: "GET",
      url: url,
      data: { page: page, pageSize:pageSize, search: search },
      success: function (data) {
        console.log(data)
        table.find('tbody').empty();
        $(data.employees).each(function (index, element) {
          var row = $('<tr>').appendTo(table.find('tbody'));
          $('<td>').text(element.id).appendTo(row);
          $('<td>').text(element.firstName).appendTo(row);
          $('<td>').text(element.lastName).appendTo(row);
          $('<td>').text(element.email).appendTo(row);
          var actionsDiv = $('<div>').addClass('btn-group').appendTo($('<td>').appendTo(row));
          var editBtn = $('<button>').text('Edit').addClass('btn btn-info').appendTo(actionsDiv);
          editBtn.click(function () {
            editEmployee(element.id, element.firstName, element.lastName, element.email);
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
        var start = ((data.currentPage - 1) * pageSize) + 1;
        var end = Math.min(start + data.pageSize - 1, filteredCount);
        var info = 'Showing ' + start + ' to ' + end + ' of ' + filteredCount + ' entries (filtered from ' + totalCount + ' total entries)';
        $('#paginationInfo').text(info);

      },
      error: function (xhr, status, error) {
        alert(xhr.responseText);
      }
    });
  }

  function editEmployee(id, firstName, lastName, email) {
    $('#id').val(id);
    $('#firstName').val(firstName);
    $('#lastName').val(lastName);
    $('#email').val(email);
    $('#submitBtn').text('Update').unbind('click').click(function (event) {
      event.preventDefault();
      var form = $('#employeeForm');
      var url = "${createLink(controller: 'employee', action: 'update')}" + '/' + id;
      if (confirm('Are you sure you want to update this employee?')) {
        $.ajax({
          type: "POST",
          url: url,
          data: form.serialize(),
          success: function (data) {
            alert('Employee updated successfully');
            form.trigger('reset');
            $('.error').text('');
            $('#submitBtn').text('Save').unbind('click').click(function (event) {
              event.preventDefault();
            });
            refreshTable();
          },
          error: function (xhr, status, error) {
            var errors = $.parseJSON(xhr.responseText);
            displayErrors(errors.errors);
          }
        });

      }
    });
  }

  function deleteEmployee(id) {
    if (confirm('Are you sure you want to delete this employee?')) {
      var url = "${createLink(controller: 'employee', action: 'delete')}" + '/' + id;
      $.ajax({
        type: "POST",
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
</script>
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/additional-methods.min.js"></script>
<script>
  $(document).ready(function() {
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
      errorElement : 'span',
      errorClass: 'text-danger text-sm',
      highlight: function(element) {
        $(element).closest('.form-group').addClass('has-error');
      },
      unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error');
      },
      errorPlacement: function(error, element) {
        if (element.attr("name") == "firstName" ) {
          error.appendTo( $("#firstNameError") );
        } else if (element.attr("name") == "lastName" ) {
          error.appendTo( $("#lastNameError") );
        } else if (element.attr("name") == "email" ) {
          error.appendTo( $("#emailError") );
        }
      }
    });
  });
</script>
</body>
</html>