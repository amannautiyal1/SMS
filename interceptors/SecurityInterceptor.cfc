component extends="coldbox.system.Interceptor" {
    
    property name="userService" inject="UserService";
    
    function preProcess(event, interceptData) {
        // Skip authentication for public endpoints
        if (listFindNoCase("auth.registerUser,auth.login", event.getCurrentEvent())) {
            return true;
        }
        
        // Get token from Authorization header
        var token = event.getHTTPHeader("Authorization", "");
        token = replace(token, "Bearer ", "");
        
        if (len(token) && userService.validateToken(token)) {
            return true;
        }
        
        event.renderData(type="json", data={
            "status": "error",
            "message": "Unauthorized access"
        }, statusCode=401);
        
        return false;
    }
}