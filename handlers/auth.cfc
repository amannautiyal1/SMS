/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{
	property name="userService" inject="models/services/UserService";
	property name="authService" inject="authenticationService@cbauth";
    property name="jwt" inject="@jwtcfml";  // Injecting the JWT package


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
		event.setView("auth/login")
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
	function loginUser(event, rc, prc) {
        try {
            // Get the form data from the request
            var username = trim(rc.username);
            var password = trim(rc.password);

            // Retrieve user by username
            var user = userService.retrieveUserByUsername(username);
            
            if (arrayLen(user) == 0) {
                // If user is not found, return error
                return event.renderData(type="json", data={
					"status": "error",
					"message": "User not found"
				}, statusCode=500);
            }
			user=user[1];
            // Check if the provided password matches the stored hash
            var isPasswordValid = userService.validatePassword(password, user.getPassword());

            if (!isPasswordValid) {
                // If the password doesn't match, return error
                return event.renderData(type="json", data={
					"status": "error",
					"message": "Password invalid"
				}, statusCode=500);
            }

            var payload = {
                "sub": user.getId(),          // Subject (User ID)
                "username": user.getUsername(), // Username
                "roles": user.getRole(),     // User roles (e.g., 'admin', 'student')
                "iat": now()  ,   // Issued at time
                "exp": dateAdd("h", 2, now()) // Expiration time (2 hours)
            };

            var secretKey = "AMAN";

            var jwtToken = jwt.encode(payload, secretKey,"HS512");

            cookie.jwtToken={value=jwtToken,  path="/", expires=30, httponly="yes", encodevalue="yes" }


            // Generate JWT token if password is valid
            // var token = userService.generateToken(user);

            // Return success with JWT token
            return event.renderData(type="json", data={
				status="success", token=jwtToken
			},statusCode=200);

        } catch (any e) {
            // Handle any errors
            return event.renderData(type="json", data={
				"status": "error",
				"message": e.message
			}, statusCode=500);
		}
    }
}

