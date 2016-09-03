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

		// getWheelsVersion will prompt and create box.json with user supplied version number
		// if there isn't one.
		var wheelsVersion=$getWheelsVersion();
		var appName=ask("Please enter an application name: we use this to make the server.json servername unique: ");
		var setEngine=ask("Please enter a default cfengine, i.e lucee@4: ");

		// Make server.json server name unique to this app: assumes lucee by default
 		print.greenline( "========= Creating default server.json" ).toConsole();
		var serverJSON = fileRead( helpers.getTemplate('/ServerJSON.txt' ) );
	 		serverJSON = replaceNoCase( serverJSON, "|appName|", trim(appName), 'all' );
	 		serverJSON = replaceNoCase( serverJSON, "|setEngine|", setEngine, 'all' );
	 		file action='write' file='#fileSystemUtil.resolvePath("server.json")#' mode ='777' output='#trim(serverJSON)#';

		// Copy over required plugins and adds urlrewrite.xml if version 1;
	 	if($isWheelsVersion(1, 'major')){
			$backPortVersion1();
 		}

	}

}
