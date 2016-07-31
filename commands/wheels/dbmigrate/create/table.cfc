/**
 * Create a migration CFC
 * 
 **/ 
 <!---
    |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
    |----------------------------------------------------------------------------------------------|
	| name       | Yes      | string  |         | table name, in pluralized form                   |
	| force      | No       | boolean | false   | drop existing table of same name before creating |
	| id         | No       | boolean | true    | if false, defines a table with no primary key    |
	| primaryKey | No       | string  | id      | overrides default primary key name
    |----------------------------------------------------------------------------------------------|

    EXAMPLE:
      t = createTable(name='employees',force=false,id=true,primaryKey='empId'); 
--->
component extends="../base"  { 
	
	property name='helpers'		inject='helpers@wheels'; 
	/**
	 * I create a migration file in /db/migrate
	 * 
	 * Usage: wheels dbmigrate create table [name] [force] [id] [primaryKey]  
	 * @name.hint The Object Name
	 * @force.hint Force Creation
	 * @id.hint Auto create ID column as autoincrement ID
	 * @primaryKey.hint overrides default primary key name
	 **/
	function run(
		required string name, 
		boolean force    = false,
		boolean id 		 = true,
		string primaryKey="id") {

		// Get Template
		var content=fileRead(helpers.getTemplate("dbmigrate/create-table.txt"));

		// Changes here 
		content=replaceNoCase(content, "|tableName|", "#name#", "all"); 
		content=replaceNoCase(content, "|force|", "#force#", "all");  
		content=replaceNoCase(content, "|id|", "#id#", "all");  
		content=replaceNoCase(content, "|primaryKey|", "#primaryKey#", "all");    

		// Make File
		 $createMigrationFile(name=lcase(trim(arguments.name)),	action="create_table",	content=content); 
	} 
}