component extends="coldbox.system.EventHandler"{
	property name="studentService" inject="models/services/UserService";
    
    
    /**
     * index
     */
    function index(){
		event.setView("student/index")
    }
    
    function getAllStudents(){
        return studentService.getAllStudents();
    }

    function createStudent(event, rc, prc) {
        rc.ROLE = "student";
        var student = studentService.createUser(rc);
        return event.renderData(type="json", data=student);
    }

    /**
     * Endpoint to generate PDF for all students
     */
    function generatePdf(event) {
        // Fetch all students with role 'student'
        var students = studentService.getAllStudents();
    
        // If no students are found, return an error message
        if (arrayLen(students) == 0) {
            return event.renderData(type="json", data={ "status": "error", "message": "No students found" });
        }
    
        // Generate a unique filename using the current date and time
        var currentDateTime = now();
        var uniqueFilename = "students_report_" & dateFormat(currentDateTime, "yyyyMMdd_HHmmss") & ".pdf";
        var pdfDirectory = expandPath("/temp/");
        var fullPath = pdfDirectory & uniqueFilename;
    
        // Prepare the PDF content
        var pdfContent = "
            <h2>Students List</h2>
            <table border='1'>
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Email</th>
                    </tr>
                </thead>
                <tbody>";
    
        // Loop over the students to generate the table rows
        for (var student in students) {
            pdfContent &= "<tr><td>#student.username#</td><td>#student.email#</td></tr>";
        }
    
        pdfContent &= "</tbody></table>";
    
        // Use cfdocument as a function to generate the PDF
        cfdocument(
            format="PDF", 
            filename="#fullPath#", 
            overwrite="true", 
            marginbottom="1", 
            margintop="1", 
            marginleft="1", 
            marginright="1"
        ){
            writeOutput(#pdfContent#)
        };
    
        // Return the generated PDF path and success message as a JSON response
        return event.renderData(type="json", data={ 
            "success": true, 
            "message": "PDF generated successfully", 
            "pdfPath": fullPath, 
            "pdfDirectory": pdfDirectory 
        });
    }
    
}