/**
 * I generate a model in /models/NAME.cfc and create associated DB Table  
 * 
 * Create "users" table and "User.cfc" in models:
 * 
 * {code:bash}
 * wheels generate model user
 * {code} 
 * 
 * Create just "User.cfc" in models:
 * 
 * {code:bash}
 * wheels generate model user false
 * {code} 
 **/
component extends="../base"  {
	 
	/**
	 * @name.hint Name of the model to create without the .cfc: assumes singluar can be foo/foo 
	 * @fields.hint Comma Delimited list of fields with type after semicolon
	 **/
	function run(
		required string name,
		boolean db=true 
	){  

    	var obj = helpers.getNameVariants(arguments.name); 
		var directory 			= fileSystemUtil.resolvePath("models");
		var appName				= listLast( getCWD(), '/\' ); 

		if(db){
			print.line( "Trying to Generate DB Tables").toConsole();  
			command('wheels dbmigrate create table #obj.objectNamePlural#').run();  
		} else {
			print.line( "Skipping DB table generation").toConsole();  
		}

		print.line( "Creating Model File..." ).toConsole();
		
		// Validate directory
		if( !directoryExists( directory ) ) {
			error( "[#directory#] can't be found. Are you running this from your site root?" );
 		}
 
 		// Read in Template
		var modelContent 	= fileRead( helpers.getTemplate('/ModelContent.txt'));  
		var modelName = obj.objectNameSingularC & ".cfc";
		var modelPath = directory & "/" & modelName;

		if(fileExists(modelPath)){
			if( confirm( '#modelName# already exists in target directory. Do you want to overwrite? [y/n]' ) ) {
			    print.greenLine( 'Ok, going to overwrite...' ).toConsole(); 
			} else { 
			    print.boldRedLine( 'Ok, aborting!' );
			    return;
			}
		}
		file action='write' file='#modelPath#' mode ='777' output='#trim( modelContent )#';
		print.line( 'Created #modelName#' ); 
	}


	 
}