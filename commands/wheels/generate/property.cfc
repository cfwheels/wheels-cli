/**
 * I generate a dbmigration to add a property to an object and scaffold into _form.cfm and show.cfm
 * i.e, wheels generate property table columnName columnType
 * 
 * Create the a string/textField property called firstname on the User model:
 * 
 * {code:bash}
 * wheels generate property user firstname
 * {code} 
 * 
 * Create the a boolean/Checkbox property called isActive on the User model:
 * 
 * {code:bash}
 * wheels generate property user isActive boolean
 * {code} 
 * 
 * Create the a datetime/datetimepicker property called lastloggedin on the User model:
 * 
 * {code:bash}
 * wheels generate property user lastloggedin datetime
 * {code} 
 * 
 * All columnType options:
 * biginteger,binary,boolean,date,datetime,decimal,float,integer,string,limit,text,time,timestamp,uuid
 *  
 **/
component extends="../base"  {
	 
	/**
	 * @name.hint Table Name 
	 * @columnName.hint Name of Column
	 * @columnType.hint Type of Column
	 * @columnType.options biginteger,binary,boolean,date,datetime,decimal,float,integer,string,limit,text,time,timestamp,uuid
	 **/
	function run(
		required string name,
		required string columnName,
		string columnType="string" 
	){  
     
    	var obj = helpers.getNameVariants(arguments.name); 

    	// Quick Sanity Checks: are we actually adding a property to an existing model?
    	// Check for existence of model file: NB, DB columns can of course exist without a model file, 
    	// But we should confirm they've got it correct.
    	if(!fileExists(fileSystemUtil.resolvePath("/models/#obj.objectNameSingularC#.cfc"))){
    		if(!confirm("Hold On! We couldn't find a corresponding Model at /models/#obj.objectNameSingularC#.cfc: are you sure you wish to add the property '#arguments.columnName#' to #obj.objectNamePlural#? [y/n]")){
    			print.line("Fair enough. Aborting!");
    			return;
    		}
    	}
    	// Create Column
		command('wheels dbmigrate create column')
			.params(name=obj.objectNamePlural,  columnName=columnName, columnType=columnType)
			.run();
		print.line("Attempting to migrate to latest DB schema");
		command('wheels dbmigrate latest').run();  

		// Insert form field
		print.line("Inserting field into view form");
		$injectIntoView(objectnames=obj, property=arguments.columnName, type=arguments.columnType, action="input"); 

		// Insert default output  
		print.line("Inserting output into views"); 
		$injectIntoView(objectnames=obj, property=arguments.columnName, type=arguments.columnType, action="output");   

	}  
	 
}