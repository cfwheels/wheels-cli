/**
 * I generate a controller in /controllers/NAME.cfc
 * Actions are passed in as arguments:
 * i.e, wheels generate controller controllerName one,two,three
 **/
component extends="../base"  { 

	/**
	 * @name Name of the controller to create without the .cfc
	 * @actionList optional list of actions, comma delimited 
	 * @directory if for some reason you don't have your controllers in /controllers/
	 **/
	function run(
		required string name,
		string actionList="", 
		directory='controllers'
	){  
		var obj = helpers.getNameVariants(arguments.name);
		var controllerContent 	= fileRead( helpers.getTemplate('/ControllerContent.txt') ); 
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );

		print.line( "Creating Controller..." ).toConsole();
		
		// Validate directory
		if( !directoryExists( arguments.directory ) ) {
			error( "[#arguments.directory#] can't be found. Are you running this from your site root?" );
 		}  
		
		// If custom actions passed in as arguments, then use them, otherwise use CRUD 
		var actionContent 		= "";

 		if( len( arguments.actionList ) && arguments.actionList != "CRUD" ){  
			var allactions = "";   
			// Loop Over actions to generate them
			for( var thisAction in listToArray( arguments.actionList ) ) {
				if( thisAction == 'init' ) { continue; }   
				allactions = allactions & $returnAction(thisAction);
				print.yellowLine( "Generated Action: #thisAction#"); 
			}
			actionContent 		= allactions;
		} else {
			// Do Crud: overrwrite whole controllerContent with CRUD template
			controllerContent = fileRead( helpers.getTemplate('/CRUDContent.txt') );
			print.yellowLine( "Generating CRUD"); 
		} 

		// Inject actions in controller content  
		controllerContent 	 = replaceNoCase( controllerContent, '|actions|', actionContent, 'all' );
		// Replace Object tokens
		controllerContent 	 = replaceNoCase( controllerContent, '|ObjectNameSingular|', obj.objectNameSingular, 'all' ); 
		controllerContent 	 = replaceNoCase( controllerContent, '|ObjectNamePlural|', obj.objectNamePlural, 'all' );

		var controllerName = obj.objectNamePlural & ".cfc";
		var controllerPath = directory & "/" & controllerName;
 
		if(fileExists(controllerPath)){
			if( confirm( '#controllerName# already exists in target directory. Do you want to overwrite? [y/n]' ) ) {
			    print.greenLine( 'Ok, going to overwrite...' ).toConsole(); 
			} else { 
			    print.boldRedLine( 'Ok, aborting!' );
			    return;
			}
		}
		file action='write' file='#controllerPath#' mode ='777' output='#trim( controllerContent )#';
		print.line( 'Created #controllerName#' );
	}
 
}