/**
 * I generate a dbmigration to add a property to an object
 * i.e, wheels generate property table columnName columnType
 * 
 *  
 **/
component {
	
	property name='helpers'		inject='helpers@wheels'; 
	/**
	 * @name.hint Table Name 
	 * @columnName.hint Name of Column
	 * @columnType.hint Type of Column
	 **/
	function run(
		required string name,
		required string columnName,
		string columnType="string" 
	){  
     
    	var obj = helpers.getNameVariants(arguments.name);

		command('wheels dbmigrate create column')
			.params(name=obj.objectNamePlural,  columnName=columnName, columnType=columnType)
			.run();
		print.line("Attempting to migrate to latest DB schema");
		command('wheels dbmigrate latest').run(); 

		// Insert form field
		print.line("Inserting field into /views/#obj.objectNamePlural#/_form.cfm");
		var target = fileSystemUtil.resolvePath("/views/#obj.objectNamePlural#/_form.cfm");
		var content = fileRead(target);
		var field = $generateFormField(objectname=obj.objectNameSingular, property=arguments.columnName, type=arguments.columnType);

		content = replaceNoCase( content, '<!--- CLI-Appends-Here --->', field & cr & '<!--- CLI-Appends-Here --->', 'all');
		content = Replace(content, "[", "##", "all");
		content = Replace(content, "]", "##", "all"); 

		file action='write' file='#target#' mode ='777' output='#trim(content)#';

	} 
 
 	function $generateFormField(required string objectName, required string property, required string type 
 		){
		var loc = {rv=""}
		switch(type){
			//cf_sql_bit,cf_sql_tinyint Return a checkbox ?
			//case "":
			//	loc.rv="textField(objectName='#objectName#', property='#property#')";
			//break;
			//cf_sql_longvarchar Return a textarea
			case "text":
				loc.rv="textArea(objectName='#objectName#', property='#property#')";
			break;		
			//cf_sql_date	 Return a calendar
			case "date":
				loc.rv="dateSelect(objectName='#objectName#', property='#property#')";
			break;	
			//cf_sql_time	Return a time picker	
			case "time":
				loc.rv="timeSelect(objectName='#objectName#', property='#property#')";
			break;		
			//cf_sql_timestamp	Return a calendar and time picker
			case "datetime":
			case "timestamp":
				loc.rv="dateTimeSelect(objectName='#objectName#', property='#property#')";
			break;  
			// Return a text if everything fails
			default:
				loc.rv="textField(objectName='#objectName#', property='#property#')";
			break;
		}
		loc.rv = "[" & loc.rv & "]";
		return loc.rv;
 	} 
}