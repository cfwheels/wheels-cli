/**
 * Create a migration CFC
 * 
 **/ 
 <!--- 
     |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                                                                                                                           |
    |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | existing table name                                                                                                                                   |
	| columnType    | Yes      | string  |         | type of column to add                                                                                                                                 |
	| columnName    | No       | string  |         | name for new column, required if columnType is not 'reference'                                                                                        |
	| referenceName | No       | string  |         | name for new reference column, see documentation for references function, required if columnType is 'reference'                                       |
	| default       | No       | string  |         | default value for column                                                                                                                              |
	| null          | No       | boolean |         | whether nulls are allowed                                                                                                                             |
	| limit         | No       | number  |         | character or integer size limit for column                                                                                                            |
	| precision     | No       | number  |         | precision value for decimal columns, i.e. number of digits the column can hold                                                                        |
	| scale         | No       | number  |         | scale value for decimal columns, i.e. number of digits that can be placed to the right of the decimal point (must be less than or equal to precision) |
    |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

    EXAMPLE:
      addColumn(table='users', columnType='string', columnName='password', default='', null=true);
--->
component extends="../../base"  { 
	 
	/**
	 * I create a migration file in /db/migrate
	 * 
	 * Usage: wheels dbmigrate create column [tablename] [force] [id] [primaryKey]  
	 **/
	function run(
		required string name,
		required string columnType,
		string columnName="", 
		any default,
		boolean null=true,
		number limit,
		number precision,
		number scale) {

		// Get Template
		var content=fileRead(helpers.getTemplate("dbmigrate/create-column.txt"));
		var argumentArr=[];
		var argumentString="";

		// Changes here 
		content=replaceNoCase(content, "|tableName|", "#name#", "all");   
		content=replaceNoCase(content, "|columnType|", "#columnType#", "all");   
		content=replaceNoCase(content, "|columnName|", "#columnName#", "all");   
		//content=replaceNoCase(content, "|referenceName|", "#referenceName#", "all"); 

		// Construct additional arguments(only add/replace if passed through)  
		if(structKeyExists(arguments,"default") && len(arguments.default)){
			if(isnumeric(arguments.default)){ 
			arrayAppend(argumentArr, "default = #arguments.default#");
			} else { 
			arrayAppend(argumentArr, "default = '#arguments.default#'");
			}
		}
		if(structKeyExists(arguments,"null") && len(arguments.null) && isBoolean(arguments.null)){
			arrayAppend(argumentArr, "null = #arguments.null#");
		}
		if(structKeyExists(arguments,"limit") && len(arguments.limit) && isnumeric(arguments.limit) && arguments.limit != 0){
			arrayAppend(argumentArr, "limit = #arguments.limit#");
		}
		if(structKeyExists(arguments,"precision") && len(arguments.precision) && isnumeric(arguments.precision) && arguments.precision != 0){
			arrayAppend(argumentArr, "precision = #arguments.precision#");
		}
		if(structKeyExists(arguments,"scale") && len(arguments.scale) && isnumeric(arguments.scale) && arguments.scale != 0){
			arrayAppend(argumentArr, "scale = #arguments.scale#");
		}
		if(arrayLen(argumentArr)){
			argumentString&=", ";
			argumentString&=$constructArguments(argumentArr);
		}
		
		// Finally, replace |arguments| with appropriate string
		content=replaceNoCase(content, "|arguments|", "#argumentString#", "all");   
		//content=replaceNoCase(content, "|null|", "#null#", "all");   
		//content=replaceNoCase(content, "|limit|", "#limit#", "all");   
		//content=replaceNoCase(content, "|precision|", "#precision#", "all");   
		//content=replaceNoCase(content, "|scale|", "#scale#", "all");   

		// Make File
		$createMigrationFile(name=lcase(trim(arguments.name)) & '_' & lcase(trim(arguments.columnName)),	action="create_column",	content=content); 
	} 

	function $constructArguments(args, string operator=","){
		var loc = {};
	    loc.array = [];
	    for (loc.i=1; loc.i <= ArrayLen(arguments.args); loc.i++) {
	        loc.array[loc.i] = "#arguments.args[loc.i]#";
	    }
	    return ArrayToList(loc.array, " #arguments.operator# ");
	}

} 