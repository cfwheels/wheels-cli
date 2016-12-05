/**
 * I generate a test stub in /test/TYPE/NAME.cfc
 *
 * {code:bash}
 * wheels generate test model user
 * {code}
 *
 * {code:bash}
 * wheels generate test controller users
 * {code}
 *
 * {code:bash}
 * wheels generate test view users edit
 * {code}
 **/
component aliases='wheels g test' extends="../base"  {

	/**
	 * @type.hint View path folder or name of object, i.e user
	 * @type.options model,controller,view
	 * @objectname.hint View path folder or name of object, i.e user
	 * @name.hint Name of the action/view
	 **/
	function run(
		required string type,
		required string objectname,
		string name
	){
		var obj = helpers.getNameVariants(listLast( arguments.objectname, '/\' ));
		var testsdirectory     = fileSystemUtil.resolvePath( "tests" );

		// Validate directories
		if( !directoryExists( testsdirectory ) ) {
			error( "[#arguments.testsdirectory#] can't be found. Are you running this from your site root?" );
 		}
 		if( arguments.type == "view" && !len(arguments.name)){
 			error( "If creating a view, we need to know the name of the view as well as the objectname");
 		}

 		// Handle type
 		switch(arguments.type){
 			case "model":
 				var testName=obj.objectNameSingularC & ".cfc";
 				var testPath=fileSystemUtil.resolvePath("tests/models/#testName#");
 			break;
 			case "controller":
 				var testName=obj.objectNamePluralC & ".cfc";
 				var testPath=fileSystemUtil.resolvePath("tests/controllers/#testName#");
 			break;
 			case "view":
 				var testName=obj.objectNamePlural & '/' &  lcase(arguments.name) & ".cfc";
 				var testPath=fileSystemUtil.resolvePath("tests/views/#testName#");
 			break;
 			default:
 				error("Unknown type: should be one of model/controller/view");
 			break;
 		}

 		if( fileExists( testPath ) ) {
			error( "[#testPath#] already exists?" );
 		}

		// Get test content
		var testContent= fileRead(helpers.getTemplate("tests/#type#.txt"));
		file action='write' file='#testPath#' mode ='777' output='#trim( testContent )#';
		print.line( 'Created Test Stub #testPath#' );
	}
}
