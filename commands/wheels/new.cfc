/**
 * Create a new CFWheels application called {name} in current working directory. Rename to {name} and navigate to after 
 * Adds various configuration defaults and does some basic checks to make URL rewriting work out of the box.
 **/
component {
	
	property name='helpers'	inject='helpers@wheels';

	function run(string name="") { 	 
 		var appContent	        = fileRead( helpers.getTemplate('/ConfigAppContent.txt' ) );
 		var settingsContent	    = fileRead( helpers.getTemplate('/ConfigSettingsContent.txt' ) );
 		var serverJSON	        = fileRead( helpers.getTemplate('/ServerJSON.txt' ) );
 		var urlRewriteContent	= fileRead( helpers.getTemplate('/urlRewriteContent.txt' ) );
 		
 		arguments.name=trim(arguments.name);

 		print.line( "========= We Need Some Information...==========" ).toConsole();

 		// TODO: Add conditions on what can in an application name
 		if(len(arguments.name) LT 2){
			arguments.name = ask( 'Please enter a name for your application: ' );
 		}
 		var reloadPassword= ask('Please enter a "reload" password for your application: ');
 		var datasourceName= ask('Please enter a datasource name if different from #arguments.name#: ');
 			if(!len(datasourceName)){
 				datasourceName = arguments.name;
 			}

		print.greenline( "========= Installing CFWheels.........." ).toConsole();
			// Note: deliberately not using cache due to https://github.com/cfwheels/cfwheels/issues/652
			command( 'artifacts remove cfwheels' ).run();
			command( 'install cfwheels' ).run();
		print.line();

		print.greenline( "========= Renaming Directory .........." ).toConsole();  
			command('mv cfwheels/ #arguments.name#/').run(); 
		print.line();

		print.greenline( "========= Navigating to new application..." ).toConsole(); 
			command('cd #arguments.name#').run();  
		print.line(); 
 
 		print.greenline( "========= Creating config/app.cfm" ).toConsole();
	 		appContent = replaceNoCase( appContent, "|appName|", arguments.name, 'all' );
	 		file action='write' file='#fileSystemUtil.resolvePath("/config/app.cfm")#' mode ='777' output='#trim(appContent)#';
 		print.line(); 

 		print.greenline( "========= Creating config/settings.cfm" ).toConsole();
	 		settingsContent = replaceNoCase( settingsContent, "|reloadPassword|", trim(reloadPassword), 'all' );
	 		settingsContent = replaceNoCase( settingsContent, "|datasourceName|", datasourceName, 'all' );
	 		file action='write' file='#fileSystemUtil.resolvePath("/config/settings.cfm")#' mode ='777' output='#trim(settingsContent)#';
 		print.line(); 

		// Make server.json server name unique to this app: assumes lucee by default
 		print.greenline( "========= Creating default server.json" ).toConsole();
	 		serverJSON = replaceNoCase( serverJSON, "|appName|", trim(arguments.name), 'all' );
	 		file action='write' file='#fileSystemUtil.resolvePath("/server.json")#' mode ='777' output='#trim(serverJSON)#'; 
 		print.line();

 		print.greenline( "========= Adding urlrewrite.xml" ).toConsole(); 
 		// TODO: Add fileExists()
	 		file action='write' file='#fileSystemUtil.resolvePath("/urlrewrite.xml")#' mode ='777' output='#trim(urlRewriteContent)#'; 
 		print.line();

		command('ls').run();  
		print.line()
		.greenBoldLine( "*****************************************************************************************" )
		.greenBoldLine( "Your app has been successfully created. Type 'server start' to start a server here." )
		.greenBoldLine( "*****************************************************************************************" )
		.line(); 
	}
 
}