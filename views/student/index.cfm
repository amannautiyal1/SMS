<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <style>
        /* General Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 900px;
        }

        h2, h3 {
            text-align: center;
            color: #444;
            margin-bottom: 20px;
        }

        /* Button styles */
        button {
            background-color: #5b9bd5;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }

        button:hover {
            background-color: #4682b4;
        }

        button:focus {
            outline: none;
            box-shadow: 0 0 5px rgba(91, 155, 213, 0.5);
        }

        /* Table styles */
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #5b9bd5;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        td button {
            padding: 8px 12px;
            background-color: #e7e7e7;
            color: #333;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        td button:hover {
            background-color: #d3d3d3;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
                width: 90%;
            }

            h2 {
                font-size: 22px;
            }

            table, th, td {
                font-size: 14px;
            }

            button {
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Welcome to the Dashboard</h2>
        <h3>Students</h3>
        <button id="addStudentButton">Add Student</button>
        <button id="generatePdfButton">Generate PDF</button>
        <table id="studentsTable">
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
        <tbody>
            <!-- Students will be dynamically populated here -->
        </tbody>
    </table>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.js"></script>

<script>
    // Fetch all students
    function fetchStudents() {
        fetch('/students', {
            method: 'GET',
        })
        .then(response => response.json())
        .then(data => {
            console.log('data : ',data);
            const tbody = document.querySelector('#studentsTable tbody');
            tbody.innerHTML = ''; // Clear current rows
            data.forEach(student => {
                let row = `<tr>
                            <td>${student.username}</td>
                            <td>${student.email}</td>
                            <td>
                                <button onclick="editStudent(${student.id})">Edit</button>
                                <button onclick="generateReport(${student.id})">Generate Report</button>
                            </td>
                        </tr>`;
                tbody.innerHTML += row;
            });
        })
        .catch(error => console.log('Error:', error));
    }

    document.getElementById('generatePdfButton').addEventListener('click', function() {
        var element = document.getElementById('studentsTable'); // Get the table element

        // Convert the table into a PDF
        html2pdf(element, {
            margin:       10,
            filename:     'students_report.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { dpi: 192, letterRendering: true },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
        });
    });
    
    // Edit Student Function
    function editStudent(studentId) {
        // You can open an edit form or redirect to edit page
        console.log('Editing student with ID:', studentId);
    }

    // Generate Report
    function generateReport(studentId) {
        var token = localStorage.getItem('authToken');
        fetch(`/students/report/${studentId}`, {
            method: 'POST',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
        .then(response => response.json())
        .then(data => alert(data.message))
        .catch(error => console.log('Error:', error));
    }

    // Call to load all students
    fetchStudents();
</script>

</body>
</html>
