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
            <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter first name"/>
            <span class="error text-danger text-sm" id="firstNameError"></span>
            <br>
        </div>

        <div class="form-group">
            <label for="lastName">Last Name</label>
            <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter last name"/>
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
      $.ajax({
        type: "POST",
        url: url,
        data: form.serialize(),
        success: function (data) {
          alert('Employee saved successfully');
          form.trigger('reset');
          $('.error').text('');
          $('#firstNameError, #lastNameError, #emailError').empty();
          refreshTable();
        },
        error: function (xhr, status, error) {
          var errors = $.parseJSON(xhr.responseText);
          displayErrors(errors.errors);
        }
      });
    });
    refreshTable();
  });

  function refreshTable() {
    var table = $('#employeeTable');
    var url = "${createLink(controller: 'employee', action: 'list')}";
    $.ajax({
      type: "GET",
      url: url,
      success: function (data) {
        table.find('tbody').empty();
        $(data).each(function (index, element) {
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
      $.ajax({
        type: "POST",
        url: url,
        data: form.serialize(),
        success: function (data) {
          alert('Employee updated successfully');
          form.trigger('reset');
          $('.error').text('');
          $('#id').val('');
          $('#submitBtn').text('Save').unbind('click').click(function (event) {
            event.preventDefault();
            saveEmployee();
          });
          refreshTable();
        },
        error: function (xhr, status, error) {
          var errors = $.parseJSON(xhr.responseText);
          displayErrors(errors.errors);
        }
      });
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
%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'employee.js')}"></script>--}%
</body>
</html>