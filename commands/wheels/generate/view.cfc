/**
 * I generate a view file in /views/VIEWNAME/NAME.cfm 
 * i.e, wheels generate view user edit
 **/
component extends="../base"  {
	 
	/**
	 * @folder View path folder, i.e user (singular)
	 * @name Name of the file to create, i.e, edit
	 * @template optional CRUD template (used in Scaffolding)
	 **/
	function run(
		required string objectname,
		required string name,
		string template=""
	){ 
		var objectName         = trim(listLast( arguments.objectname, '/\' ));
		var objectNameSingular = lcase(helpers.singularize(objectName));
		var objectNamePlural   = lcase(helpers.pluralize(objectName));  
		var objectNameSingularC = helpers.capitalize(objectNameSingular);
		var objectNamePluralC   = helpers.capitalize(objectNamePlural);  
		var viewdirectory     = fileSystemUtil.resolvePath( "views" ); 
		var directory 		  = fileSystemUtil.resolvePath( "views" & "/" & objectNamePlural); 
		print.line( "Creating View File..." ).toConsole();
		
		// Validate directory
		if( !directoryExists( viewdirectory ) ) {
			error( "[#arguments.viewdirectory#] can't be found. Are you running this from your site root?" );
 		}  

 		// Validate views subdirectory, create if doesnt' exist
 		if( !directoryExists( directory ) ) {
 			print.line( "#directory# doesnt exist... creating" ).toConsole();
 			directoryCreate(directory);
 			print.line( "#directory# created" ).toConsole();
 		}
 
 		// Read in Template
		var viewContent 	= ""; 
 		if(!len(arguments.template)){
 			viewContent 	= fileRead( helpers.getTemplate( '/viewContent.txt')); 
		} else {
			viewContent 	= fileRead( helpers.getTemplate( arguments.template & '.txt')); 
		}  
		// Replace Object tokens
		viewContent 	 = replaceNoCase( viewContent, '|ObjectNameSingular|', objectNameSingular, 'all' ); 
		viewContent 	 = replaceNoCase( viewContent, '|ObjectNamePlural|', objectNamePlural, 'all' );
		viewContent 	 = replaceNoCase( viewContent, '|ObjectNameSingularC|', objectNameSingularC, 'all' ); 
		viewContent 	 = replaceNoCase( viewContent, '|ObjectNamePluralC|', objectNamePluralC, 'all' );
		var viewName = lcase(arguments.name) & ".cfm";
		var viewPath = directory & "/" & viewName;

		if(fileExists(viewPath)){
			if( confirm( '#viewName# already exists in target directory. Do you want to overwrite? [y/n]' ) ) {
			    print.greenLine( 'Ok, going to overwrite...' ).toConsole(); 
			} else { 
			    print.boldRedLine( 'Ok, aborting!' );
			    return;
			}
		}
		file action='write' file='#viewPath#' mode ='777' output='#trim( viewContent )#';
		print.line( 'Created #viewName#' );
	} 
}