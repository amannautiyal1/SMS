component 
    singleton 
    extends="cborm.models.BaseORMService"
{
    // Dependencies
    // property name="jwtService" inject="@jwt-cfml";
    property name="bcrypt" inject="@BCrypt";
    property name = "userService" inject="entityService:User"
    // property name="jwtService" inject="@jwt-cfml";   // Or inject your own JWT service here

    /**
     * Constructor
     */
    function init(){
        // Initialize the super class with the User entity
        super.init(entityName="User");
        return this;
    }
    
    /**
     * Create a new user
     */
    function createUser(event, rc, prc) {
		try {
			// Get the form data from the request
			var Username = trim(rc.USERNAME);
			var Password = trim(rc.PASSWORD);
			var Email = trim(rc.EMAIL);
			var Role = rc.ROLE;

			
			user1=userService.new({username = Username, password = Password, email = Email, role = Role});
			
			prc.user = userService.save(user1).getMemento(includes = "id");


            // Return the token in the response
            return {
                "status" = "success",
                "message" = "User registered successfully.",
                "user" = prc.user
            }
		}catch (any e) {
			rc.status = 500;
			rc.message = e.message;
		}

		return rc;
	}

    /**
     * Retrieve a user by username
     */
    function retrieveUserByUsername(required username) {
        return findWhere({username = arguments.username});
    }

    /**
     * Retrieve a user by ID
     */
    function retrieveUserById(required id) {
        return get(arguments.id);
    }

    /**
     * Generate JWT token
     */
    function generateToken(required user) {
        var claims = {
            "sub": arguments.user.getId(),
            "username": arguments.user.getUsername(),
            "role": arguments.user.getRole(),
            "exp": dateAdd("h", 24, now())
        };
        
        return jwtService.encode(claims);
    }
    
    /**
     * Validate JWT token
     */
    function validateToken(required string token) {
        try {
            return jwtService.decode(arguments.token);
        } catch(any e) {
            return false;
        }
    }
}
