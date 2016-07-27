/**
 * I generate a model in /models/NAME.cfc 
 * i.e, wheels generate model user
 **/
component {
	
	property name='helpers'	inject='helpers@wheels';
	/**
	 * @name Name of the model to create without the .cfc: assumes singluar 
	 * @directory if for some reason you don't have your models in /models/
	 **/
	function run(
		required string name, 
		directory='models'
	){  

		var objectName         = trim(listLast( arguments.name, '/\' ));
		var objectNameSingluar = lcase(helpers.singularize(objectName)); 

		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		print.line( "Creating Model..." ).toConsole();
		
		// Validate directory
		if( !directoryExists( arguments.directory ) ) {
			error( "[#arguments.directory#] can't be found. Are you running this from your site root?" );
 		}
 
 		// Read in Template
		var modelContent 	= fileRead( helpers.getTemplate('/ModelContent.txt'));  
		
		// Basic replacements
		modelContent 	 = replaceNoCase( modelContent, '|modelName|', objectNameSingluar, 'all' ); 

		var modelName = helpers.capitalize(objectNameSingluar) & ".cfc";
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