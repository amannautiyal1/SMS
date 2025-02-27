component persistent="true" table="users" entityname="User" 
{

	property name="id" fieldtype="id" column="id" generator="native" setter="false";
    property name="username" columntype="varchar(255)" unique="true";
    property name="password"  columntype="varchar(255)";
    property name="role"  columntype="varchar(255)";
    property name="email"  columntype="varchar(255)";

    property name="bcrypt" inject="@bcrypt" persistent="false";

    this.constraints = {
		"role" : { required = true },
		"password"  : { required = true },
		"username"  : { required = true, validator="UniqueValidator@cborm" }
	};
    public void function preInsert(){
        variables.password = bcrypt.hashPassword(variables.password);
    }
}
