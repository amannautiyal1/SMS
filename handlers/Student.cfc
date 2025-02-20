component extends="coldbox.system.EventHandler"{
	property name="studentService" inject="models/services/UserService";
    
    // Email configuration
    variables.SMTP_SERVER = "smtp.gmail.com";
    variables.SMTP_PORT = "587";
    variables.SMTP_USERNAME = "pulukuriabhiram2024@gmail.com";
    variables.SMTP_PASSWORD = "tebb sidt iyjd aket"; // Replace with actual app password
    variables.FROM_EMAIL = "pulukuriabhiram2024@gmail.com";
    
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
    
        // Email the generated PDF
        var emailSubject = "Students Report - #dateFormat(currentDateTime, 'yyyy-MM-dd')#";
        var emailTo = "aman.nautiyal@bizacuity.com"; // Replace with actual recipient email
        var emailFrom = "sender@example.com";  // Replace with sender email
        var emailMessage = "Please find the attached PDF report for the students.";

        // Sending email with PDF attachment
        cfmail(
            to="#emailTo#",
            from="#emailFrom#",
            subject="#emailSubject#",
            type="html",
            server = variables.SMTP_SERVER,
            username = variables.SMTP_USERNAME,
            password = variables.SMTP_PASSWORD,
            port = variables.SMTP_PORT,
            useTLS = true
        ) {
            // writeOutput("#emailMessage#");
            cfmailparam(
                file="#fullPath#",
                disposition="attachment",
                type = "application/pdf"
            );
        }


        // Return the generated PDF path and success message as a JSON response
        return event.renderData(type="json", data={ 
            "success": true, 
            "message": "PDF generated successfully", 
            "pdfPath": fullPath, 
            "pdfDirectory": pdfDirectory 
        });
    }
    
}