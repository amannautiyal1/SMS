/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{

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
	// Get token from request headers (or from session/localStorage)
	// var token = rc.HTTP_AUTHORIZATION;

	// Check if token is provided
	// if (isEmpty(token)) {
	// 	rc.status = 401;
	// 	rc.message = "Unauthorized access. Please provide a valid token.";
	// 	return rc;
	// }

		// Secret key used for validating the JWT
		var secretKey = "AMAN";  // Same secret key used for signing the token

		try {
			// Decode and validate the JWT
			// var decodedJWT = decodeJWT(token, secretKey);

			// If the token is valid, render the home page view
			return event.renderView(view="home/index");
		} catch (any e) {
			// Token validation failed
			rc.status = 401;
			rc.message = "Invalid token. Please log in again.";
			return rc;
		}
	}



}

