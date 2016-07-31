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
component extends="../base"  { 
	
	property name='helpers'		inject='helpers@wheels'; 
	/**
	 * I create a migration file in /db/migrate
	 * 
	 * Usage: wheels dbmigrate create column [tablename] [force] [id] [primaryKey]  
	 **/
	function run(
		required string name,
		required string columnType,
		string columnName="",
		string referenceName="",
		string default="",
		boolean null=true,
		number limit=0,
		number precision=0,
		number scale=0) {

		// Get Template
		var content=fileRead(helpers.getTemplate("dbmigrate/create-column.txt"));

		// Changes here 
		content=replaceNoCase(content, "|tableName|", "#name#", "all");   
		content=replaceNoCase(content, "|columnType|", "#columnType#", "all");   
		content=replaceNoCase(content, "|columnName|", "#columnName#", "all");   
		content=replaceNoCase(content, "|referenceName|", "#referenceName#", "all");   
		content=replaceNoCase(content, "|default|", "#default#", "all");   
		content=replaceNoCase(content, "|null|", "#null#", "all");   
		content=replaceNoCase(content, "|limit|", "#limit#", "all");   
		content=replaceNoCase(content, "|precision|", "#precision#", "all");   
		content=replaceNoCase(content, "|scale|", "#scale#", "all");   

		// Make File
		 $createMigrationFile(name=lcase(trim(arguments.name)),	action="create_column",	content=content); 
	} 
} 