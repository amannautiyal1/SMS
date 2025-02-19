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
}