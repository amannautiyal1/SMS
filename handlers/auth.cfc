/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{
	property name="userService" inject="models/services/UserService";
	property name="authService" inject="authenticationService@cbauth";


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
	function index( event, rc, prc ){

	}
	
	
	/**
	 * login
	 */
	function login(event,rc,prc){
		// event.setView("auth/login")
	}
	

	/**
	 * register
	 */
	function register(event,rc,prc){
		event.setView("auth/register")
	}


		function registerUser(event, rc, prc) {
        try {
            // Get the form data
            var userData = {
                username = trim(rc.username),
                password = trim(rc.password),
                email = trim(rc.email),
                role = rc.role
            };
            
            // Create user using our service method
            var user = userService.createUser(event, rc, prc);
            
            // Log the user in
            // authService.authenticate(userData.username, userData.password);
            
            // Generate JWT token
            // var token = userService.generateToken(user);
            
            // Return success response with token
            event.renderData(type="json", data={
                "status": "success",
                "message": "User registered successfully",
                "user": user
            });
            
        } catch (any e) {
            event.renderData(type="json", data={
                "status": "error",
                "message": e.message
            }, statusCode=500);
        }
    }
}

