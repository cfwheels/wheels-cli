/**
 * Create a new CFWheels application called {name} in current working directory. Rename to {name} and navigate to after 
 * Adds various configuration defaults and does some basic checks to make URL rewriting work out of the box.
 **/
component {
	
	property name='helpers'	inject='helpers@wheels';

	function run() { 	 
 		var appContent	        = fileRead( helpers.getTemplate('/ConfigAppContent.txt' ) );
 		var settingsContent	    = fileRead( helpers.getTemplate('/ConfigSettingsContent.txt' ) );
 		var serverJSON	        = fileRead( helpers.getTemplate('/ServerJSON.txt' ) );
 		var urlRewriteContent	= fileRead( helpers.getTemplate('/urlRewriteContent.txt' ) );
  

 		//---------------- Welcome
 		print.greenBoldLine( "========= Hello! =================================" )
 			 .greenBoldLine( "= Welcome to the CFWheels app wizard. We're here =" )
 			 .greenBoldLine( "= to try and give you a helping start for your   =" )
 			 .greenBoldLine( "= first app.                                     =" )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();

 	    //---------------- Set an app Name
 		// TODO: Add conditions on what can in an application name 
 		print.greenBoldLine( "========= We Need Some Information...=============" ) 			 
 			 .greenBoldLine( "= To get going, we're going to need to know a    =" )
 			 .greenBoldLine( "= NAME for your application. We recommend        =" )
 			 .greenBoldLine( "= something like myapp to start with             =" )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();
		var appName = ask( 'Please enter a name for your application: ' );
			appName=trim(appName);	
			// TODO: Check appname is sane, and doesn't already exist.
		print.line();

 	    //---------------- Set reload Password
  		print.greenBoldLine( "========= And a 'Reload' Password    =============" ) 			 
			 .greenBoldLine( "= We also need a 'reload' password. This can be  =" )
			 .greenBoldLine( "= something simple, but unique and known only to =" )
			 .greenBoldLine( "= you; Your reload password allows you to restart=" )
			 .greenBoldLine( "= your app via the URL. You can change it later  =" )
			 .greenBoldLine( "= if you need! 								   =" )
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
 		var reloadPassword= ask('Please enter a "reload" password for your application: ');
 		print.line();
 		
 	    //---------------- Set datasource Name
  		print.greenBoldLine( "========= Data...data...data..       =============" ) 			 
			 .greenBoldLine( "= All good apps need data. Unfortunately you're  =" ) 		 
			 .greenBoldLine( "= going to have to be responsible for this bit.  =" ) 		 
			 .greenBoldLine( "= We're expecting  a valid DataSource to be      =" ) 		 
			 .greenBoldLine( "= setup; so you'll need mySQL or some other      =" ) 
			 .greenBoldLine( "= supported DB server running locally. Once      =" ) 
			 .greenBoldLine( "= you've setup a database, you'll need to add it =" ) 
			 .greenBoldLine( "= to the local CommandBox Lucee server which     =" ) 
			 .greenBoldLine( "= we'll start in a bit. For now, we just need to =" ) 
			 .greenBoldLine( "= know what that datasource name will be.        =" ) 
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
 		var datasourceName= ask('Please enter a datasource name if different from #appName#: ');
 			if(!len(datasourceName)){
 				datasourceName = appName;
 			}
		print.line();
 		
 		//---------------- This is just an idea at the moment really.
  		print.greenBoldLine( "========= Twitter Bootstrap ======================" ).toConsole();
		var useBootstrap3=false;
	    if(confirm("Would you like us to setup some default Bootstrap3 settings? [y/n]")){
	    	useBootstrap3 = true;
	    } 

		print.greenBoldLine( "==================================================" );
 		if(confirm("Great! Think we all good to go. We're going to install CFWheels in '/#appName#/', with a reload password of '#reloadPassword#', and a datasource of '#datasourceName#'. Sound good? [y/n]")){

 			print.greenline( "========= Installing CFWheels.........." ).toConsole();
			// Note: deliberately not using cache due to https://github.com/cfwheels/cfwheels/issues/652
			command( 'artifacts remove cfwheels' ).run();
			command( 'install cfwheels' ).run(); 

			print.greenline( "========= Renaming Directory .........." ).toConsole();  
				command('mv cfwheels/ #appName#/').run();  

			print.greenline( "========= Navigating to new application..." ).toConsole(); 
				command('cd #appName#').run();   
	 
	 		print.greenline( "========= Creating config/app.cfm" ).toConsole();
		 		appContent = replaceNoCase( appContent, "|appName|", appName, 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("/config/app.cfm")#' mode ='777' output='#trim(appContent)#'; 

	 		print.greenline( "========= Creating config/settings.cfm" ).toConsole();
		 		settingsContent = replaceNoCase( settingsContent, "|reloadPassword|", trim(reloadPassword), 'all' );
		 		settingsContent = replaceNoCase( settingsContent, "|datasourceName|", datasourceName, 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("/config/settings.cfm")#' mode ='777' output='#trim(settingsContent)#'; 

			// Make server.json server name unique to this app: assumes lucee by default
	 		print.greenline( "========= Creating default server.json" ).toConsole();
		 		serverJSON = replaceNoCase( serverJSON, "|appName|", trim(appName), 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("/server.json")#' mode ='777' output='#trim(serverJSON)#';  

	 		print.greenline( "========= Adding urlrewrite.xml" ).toConsole(); 
	 		// TODO: Add fileExists() as this will br provided in 2.x
		 		file action='write' file='#fileSystemUtil.resolvePath("/urlrewrite.xml")#' mode ='777' output='#trim(urlRewriteContent)#';  

	 		print.greenline( "========= Installing DBMigrate and DBMigratebridge Plugins").toConsole();
	 			command( 'cp' )
				    .params( path=expandPath("../modules/cfwheels-cli/plugins"), newPath='/plugins/', filter="*.zip" )
				    .run();
	 		print.line();

	 		// Definitely refactor this into some sort of templating system?
	 		if(useBootstrap3){
	 		print.greenline( "========= Installing Bootstrap3 Settings").toConsole();
	 		 	// Replace Default Template with something more sensible
	 		 	var bsLayout=fileRead( helpers.getTemplate('/bootstrap3/layout.cfm' ) );
	 		 		bsLayout = replaceNoCase( bsLayout, "|appName|", appName, 'all' );
	 		 		file action='write' file='#fileSystemUtil.resolvePath("/views/layout.cfm")#' mode ='777' output='#trim(bsLayout)#';  
	 		 	// Add Bootstrap 3 default form settings
	 		 	var bsSettings=fileRead( helpers.getTemplate('/bootstrap3/settings.cfm' ) );
				settingsContent = replaceNoCase( settingsContent, '// CLI-Appends-Here', bsSettings & cr & '// CLI-Appends-Here', 'one');
				file action='write' file='#fileSystemUtil.resolvePath("/config/settings.cfm")#' mode ='777' output='#trim(settingsContent)#'; 
	 		 	// Flashwrapper Plugin needed 
	 		 	command( 'cp' )
				    .params( path=expandPath("../modules/cfwheels-cli/templates/bootstrap3/plugins/"), newPath='/plugins/', filter="*.zip" )
				    .run();
	 		print.line();
		    }
	 		
			command('ls').run();  
			print.line()
			print.greenBoldLine( "========= All Done! =============================" ) 			 
				 .greenBoldLine( "= Your app has been successfully created. Type   =" ) 		 
				 .greenBoldLine( "= 'server start' to start a server here.         =" ) 		 
				 .greenBoldLine( "=                                                =" ) 		 
				 .greenBoldLine( "= Once you've started a local server, we can get =" ) 
				 .greenBoldLine( "= going with scaffolding and other awesome things=" )  
				 .greenBoldLine( "==================================================" )
				 .line(); 
		} else {
			error("OK, another time then. *sobs*");
		} 

		
	}
 
}