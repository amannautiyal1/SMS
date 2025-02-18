/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{

	property name="studentService" inject="entityService:Student";

	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";
	this.allowedMethods = {};

	/**
	 * Display a listing of the resource
	 */
	// function index( event, rc, prc ){
	// 	event.setView("student/index")
	// }

    /**
     * create a Student
     */
    
    function create(event, rc, prc)
    {
        prc.student = studentService.new({firstName = "Luis", lastName = "Wood", email = "louis@gmail.com"});;
        return studentService.save(prc.student).getMemento(includes = "id");
    }
    

}

