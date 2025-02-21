    component extends="coldbox.system.EventHandler"{
        property name="studentService" inject="models/services/UserService";
        property name="jwt" inject="@jwtcfml";  // Injecting the JWT package
        
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
            //validate -> later move it to interceptor
            var tokenValue=cookie.jwtToken;
            if(len(trim(tokenValue)) == 0){
                return event.renderData(type="json", data={
                    "status": "error",
                    "message": "token not present"
                }, statusCode=401); 
            }
            var decodedValue = jwt.decode(tokenValue,"AMAN","HS512");
            if (isDefined("decodedValue") AND NOT structIsEmpty(decodedValue)) {
                if(decodedValue.roles!=="admin")return event.renderData(type="json", data={
                    "status": "error",
                    "message": "you can not see list of students"
                }, statusCode=401); 
                return studentService.getAllStudents();
            }
            else{
                return event.renderData(type="json", data={
                    "status": "error",
                    "message": "you can not see list of students"
                }, statusCode=401); 
            }
        }

        function createStudent(event, rc, prc) {
            rc.ROLE = "student";
            var student = studentService.createUser(rc);
            return event.renderData(type="json", data=student);
        }

        /**
         * Endpoint to generate PDF for all students
         */
        function generatePdf(event,rc) {
            try{
            var username = trim(rc.username);
            var students = studentService.retrieveUserByUsername(username);
            if (arrayLen(students) == 0) {
                // If user is not found, return error
                return event.renderData(type="json", data={
                    "status": "error",
                    "message": "Student not found"
                }, statusCode=500);
            }
            var student=students[1];
            // Generate a unique filename using the current date and time
            var currentDateTime = now();
            var uniqueFilename = "students_report_" & dateFormat(currentDateTime, "yyyyMMdd_HHmmss") & ".pdf";
            var pdfDirectory = expandPath("/temp/");
            var fullPath = pdfDirectory & uniqueFilename;
        
           // Prepare the PDF content
var pdfContent = "
<html>
    <head>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                margin: 40px;
                color: DarkSlateGray;
                background-color: LightGray;
            }
            h1 {
                text-align: center;
                color: RoyalBlue;
                font-size: 36px;
                margin-bottom: 20px;
            }
            h2 {
                color: RoyalBlue;
                font-size: 24px;
                margin-top: 40px;
                border-bottom: 2px solid RoyalBlue;
                padding-bottom: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            td {
                font-size: 14px;
                padding: 10px;
                border: 1px solid LightSlateGray;
                text-align: left;
                background-color: White;
            }
            .label {
                font-weight: bold;
                color: DarkSlateGray;
            }
            .footer {
                text-align: center;
                margin-top: 30px;
                font-size: 14px;
                color: DarkSlateGray;
            }
            .terms {
                margin-top: 20px;
                font-size: 12px;
                color: DimGray;
                text-align: justify;
            }
        </style>
    </head>
    <body>
        <h1>Student Admission Slip</h1>

        <h2>Admission Details</h2>
        <table>
            <tr>
                <td class='label'>Username:</td>
                <td>#student.getUsername()#</td>
            </tr>
            <tr>
                <td class='label'>Course:</td>
                <td>Computer Science</td>
            </tr>
            <tr>
                <td class='label'>Admission Date:</td>
                <td>#dateFormat(now(), 'yyyy-mm-dd')#</td>
            </tr>
        </table>

        <h2>Important Notes</h2>
        <div class='terms'>
            <p>1. Please keep this admission slip for future reference.</p>
            <p>2. For any queries, feel free to contact the admission office.</p>
            <p>3. Ensure all details are accurate. If any discrepancies are found, please contact us immediately.</p>
            <p>4. Payment should be completed before the start of the course to secure your seat.</p>
        </div>

        <div class='footer'>
            <p>Thank you for choosing our institution.</p>
            <p>For more information, visit our website or contact the admission office.</p>
        </div>
    </body>
</html>";

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
            var emailMessage = "Please find the attached PDF report of your admission slip";

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
                writeOutput("#emailMessage#");
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
    catch (any e) {
        event.renderData(type="json", data={
            "status": "error",
            "message": e.message
        }, statusCode=500);
    }
        }
        
    }