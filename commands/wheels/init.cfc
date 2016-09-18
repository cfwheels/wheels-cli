/**
 * Init: This will attempt to bootstrap an EXISTING wheels app to work with the CLI.
 *
 * We'll assume: the database/datasource exists, the other config, like reloadpassword is set
 * If there's no box.json, create it, and ask for the version number
 * If there's no server.json, create it, and ask for cfengine preference
 * We'll ignore the bootstrap3 templating, as this will probably be in place too.
 **/
component  extends="base"  {

	/**
	 *
	 **/
	function run() {

		print.greenBoldLine( "========= Wheels init ============================" )
			 .greenBoldLine( "= This function will attempt to add a few things " )
			 .greenBoldLine( "= to an EXISTING CFWheels installation to help   " )
			 .greenBoldLine( "= the CLI interact." )
			 .greenBoldLine( "= " )
			 .greenBoldLine( "= We're going to assume the following:" )
			 .greenBoldLine( "=  - you've already setup a local datasource/database" )
			 .greenBoldLine( "=  - you've already set a reload password" )
			 .greenBoldLine( "= " )
			 .greenBoldLine( "= We're going to try and do the following:" )
			 .greenBoldLine( "=  - create a box.json to help keep track of the wheels version" )
			 .greenBoldLine( "=  - create a server.json" )
			 .greenBoldLine( "=  - if wheels 1.x - add urlrewrite.xml" )
			 .greenBoldLine( "=  - if wheels 1.x - add a couple of plugins, such as dbmigrate" )
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
		if(!confirm("Sound ok? [y/n] ")){
			error("Ok, aborting...");
		}

		var serverJsonLocation=fileSystemUtil.resolvePath("server.json");

		// getWheelsVersion will prompt and create box.json with user supplied version number
		// if there isn't one.
		var wheelsVersion = $getWheelsVersion();

		// Create a server.json if one doesn't exist
		if(!fileExists(serverJsonLocation)){
			var appName       = ask("Please enter an application name: we use this to make the server.json servername unique: ");
				appName 	  = helpers.stripSpecialChars(appName);
			var setEngine     = ask("Please enter a default cfengine, i.e lucee@4: ");

			// Make server.json server name unique to this app: assumes lucee by default
	 		print.greenline( "========= Creating default server.json" ).toConsole();
			var serverJSON = fileRead( helpers.getTemplate('/ServerJSON.txt' ) );
		 		serverJSON = replaceNoCase( serverJSON, "|appName|", trim(appName), 'all' );
		 		serverJSON = replaceNoCase( serverJSON, "|setEngine|", setEngine, 'all' );
		 		file action='write' file=serverJsonLocation mode ='777' output='#trim(serverJSON)#';

		} else {
 			print.greenline( "========= server.json exists, skipping" ).toConsole();
		}

		// Copy over required plugins and adds urlrewrite.xml if version 1;
	 	if($isWheelsVersion(1, 'major')){
			$backPortVersion1();
 		}

	}

}
