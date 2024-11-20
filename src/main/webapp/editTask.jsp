<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Task</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            padding-top: 56px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
        <a class="navbar-brand" href="#">Task Management System</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="lecturerDashboard.jsp">Back</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2 class="text-center">Edit Task</h2>
        <form action="manageTasks" method="post">
            <input type="hidden" name="task_id" value="${task.id}">
            <div class="form-group">
                <label for="title">Title</label>
                <input type="text" class="form-control" id="title" name="title" value="${task.title}" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3" required>${task.description}</textarea>
            </div>
            <div class="form-group">
                <label for="department_id">Department</label>
                <select class="form-control" id="department_id" name="department_id" required>
                    <option value="1" ${task.department_id == 1 ? "selected" : ""}>ICT</option>
                    <option value="2" ${task.department_id == 2 ? "selected" : ""}>Civil</option>
                    <option value="3" ${task.department_id == 3 ? "selected" : ""}>Logistics</option>
                    <option value="4" ${task.department_id == 4 ? "selected" : ""}>Mechanical</option>
                    <option value="5" ${task.department_id == 5 ? "selected" : ""}>Electricity</option>
                    <option value="6" ${task.department_id == 6 ? "selected" : ""}>Fashion & Design</option>
                    <option value="7" ${task.department_id == 7 ? "selected" : ""}>Art Creative</option>
                </select>
            </div>
            <button type="submit" name="action" value="update" class="btn btn-primary">Update Task</button>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
