/**
 * Creates a new CFWheels application. This is the recommended route 
 * to start a new application.
 *
 * This command will ask for:
 *
 *  - An Application Name (a new directoery will be created with this name)
 *  - What wheels version you want to install
 *  - A reload Password
 *  - A datasource name
 *  - What local cfengine you want to run
 *  - If using Lucee, do you want to setup a local h2 dev database
 *  - Do you want to setup some basic Bootstrap templating
 *
 * {code:bash}
 * wheels new
 * {code}
 **/
component extends="base"  {


	function run() {
 		var appContent	        = fileRead( helpers.getTemplate('/ConfigAppContent.txt' ) );
 		var settingsContent	    = fileRead( helpers.getTemplate('/ConfigSettingsContent.txt' ) );
 		var routesContent	    = fileRead( helpers.getTemplate('/ConfigRoutes.txt' ) );

 		//---------------- Welcome
 		print.greenBoldLine( "========= Hello! =================================" )
 			 .greenBoldLine( "Welcome to the CFWheels app wizard. We're here" )
 			 .greenBoldLine( "to try and give you a helping hand to install " )
 			 .greenBoldLine( "your initial app.                            " )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();

 	    //---------------- Set an app Name
 		// TODO: Add conditions on what can in an application name
 		print.greenBoldLine( "========= We Need Some Information... ============" )
 			 .greenBoldLine( "To get going, we're going to need to know a    " )
 			 .greenBoldLine( "NAME for your application. We recommend        " )
 			 .greenBoldLine( "something like myapp to start with. Keep in    " )
 			 .greenBoldLine( "mind that a new directory will be created for  " )
 			 .greenBoldLine( "your app in #getCWD()#.                        " )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();
		var appName = ask( message='Please enter a name for your application: ', defaultResponse="myapp" );
			appName=helpers.stripSpecialChars(appName);
		print.line();

		//---------------- Version
 		print.greenBoldLine( "========= CF Wheels Version?... ==================" )
 			 .yellowBoldLine("1) Latest Stable Release                     " )
 			 .greenBoldLine( "2) Bleeding Edge (Current Master Branch)     " )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();
		var version = ask( message='Please enter your preferred version [1-2]: ' , defaultResponse='1');
			switch(version){
 				case 1:
 					setVersion="cfwheels";
 				break;
 				case 2:
 					setVersion="cfwheels/cfwheels";
 				break;
 			}
		print.line();

 	    //---------------- Set reload Password
  		print.greenBoldLine( "========= And a 'Reload' Password ================" )
			 .greenBoldLine( "We also need a 'reload' password. This can be  " )
			 .greenBoldLine( "something simple, but unique and known only to " )
			 .greenBoldLine( "you; Your reload password allows you to restart" )
			 .greenBoldLine( "your app via the URL. You can change it later  " )
			 .greenBoldLine( "if you need! 								     " )
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
 		var reloadPassword= ask(message='Please enter a "reload" password for your application: ', defaultResponse="changeMe");
 		print.line();

 	    //---------------- Set datasource Name
  		print.greenBoldLine( "========= Data...data...data..       =============" )
			 .greenBoldLine( "All good apps need data. Unfortunately you're   " )
			 .greenBoldLine( "going to have to be responsible for this bit.   " )
			 .greenBoldLine( "We're expecting a valid DataSource to be        " )
			 .greenBoldLine( "setup; so you'll need mySQL or some other       " )
			 .greenBoldLine( "supported DB server running locally. Once       " )
			 .greenBoldLine( "you've setup a database, you'll need to add it  " )
			 .greenBoldLine( "to the local CommandBox Lucee server which      " )
			 .greenBoldLine( "we'll start in a bit. For now, we just need to  " )
			 .greenBoldLine( "know what that datasource name will be.         " )
			 .greenBoldLine( "                                                " )
			 .greenBoldLine( "If you're going to run lucee, we can autocreate " )
			 .greenBoldLine( "a development database for you later.           " )
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
 		var datasourceName= ask(message='Please enter a datasource name if different from #appName#: ', defaultResponse="#appName#");
 			if(!len(datasourceName)){
 				datasourceName = appName;
 			}
		print.line();



 	    //---------------- Set default server.json engine
  		print.greenBoldLine( "========= Default CFML Engine        =============" )
			 .greenBoldLine( "Please select your preferred CFML engine for   " )
			 .greenBoldLine( "local development: you can always change it    " )
			 .greenBoldLine( "later!                                         " )
			 .greenBoldLine( "                                               " )
			 .yellowBoldLine(" 1) Lucee (Latest Stable Release)              " )
			 .greenBoldLine( " 2) Adobe ColdFusion (Latest Stable Release)   " )
			 .greenBoldLine( " 3) Lucee 5.x                                  " )
			 .greenBoldLine( " 4) Lucee 4.x                                  " )
			 .greenBoldLine( " 5) Adobe ColdFusion 2021                      " )
			 .greenBoldLine( " 6) Adobe ColdFusion 2018                      " )
			 .greenBoldLine( " 7) Adobe ColdFusion 2016                      " )
			 .greenBoldLine( " 8) Adobe ColdFusion 11                        " )
			 .greenBoldLine( " 9) Adobe ColdFusion 10                        " )
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
 		var defaultEngine= ask(message='Please enter your preferred engine: [1-9] ', defaultResponse="1");
 		var setEngine="lucee";
 		var allowH2Creation=false;
 			switch(defaultEngine){
 				case 1:
 					setEngine="lucee";
 					allowH2Creation=true;
	 				break;
 				case 2:
 					setEngine="adobe";
 					break;
 				case 3:
 					setEngine="lucee@5";
 					allowH2Creation=true;
 					break;
 				case 4:
 					setEngine="lucee@4";
 					allowH2Creation=true;
 					break;
 				case 5:
 					setEngine="adobe@2021";
 					break;
 				case 6:
 					setEngine="adobe@2018";
 					break;
				case 7:
 					setEngine="adobe@2016";
 					break;
				case 8:
 					setEngine="adobe@11";
 					break;
				case 9:
 					setEngine="adobe@10";
 					break;
 			}
		print.line();

		//---------------- Test H2 Database?
		if(allowH2Creation){
			print.greenBoldLine( "========= Setup H2 Database ======================" )
			.greenBoldLine( "As you are using Lucee, would you like to setup        " )
			.greenBoldLine( "and use the H2 Java embedded SQL database:             " )
			.line()
		  .yellowBoldLine("1) Yes, setup the H2 database for me                   " )
		  .greenBoldLine( "2) No, I'll setup my own database for development      " )
		  .greenBoldLine( "==================================================" )
		  .line().toConsole();
			var version = ask( message='Please enter your selection [1-2]: ' , defaultResponse='1');
			switch(version){
				case 1:
					createH2Embedded=true;
					break;
				case 2:
					createH2Embedded=false;
					break;
			}
			print.line();
		} else {
			createH2Embedded=false;
		}

 		//---------------- This is just an idea at the moment really.
  		print.greenBoldLine( "========= Twitter Bootstrap ======================" ).toConsole();
		var useBootstrap3=false;
	    if(confirm("Would you like us to setup some default Bootstrap3 settings? [y/n]")){
	    	useBootstrap3 = true;
	    }

		print.line();
		print.line();
		print.greenBoldLine( "==================================================" )
		.greenBoldLine( "Great! Think we're all good to go. We're going to ")
		.greenBoldLine( "install CFWheels in '#getCWD()##appName#', ") 
		.greenBoldLine( "with a reload password of '#reloadPassword#',")
		.greenBoldLine( "and a datasource of '#datasourceName#'.").toConsole();
		print.line();
		if(allowH2Creation && createH2Embedded){
			print.greenBoldLine( "We're also going to try and setup an embedded H2 " )
			.greenBoldLine( "database for development mode. Pleae log into the     " )
			.greenBoldLine( "Lucee Server admin and make sure the H2 Lucee " )
			.greenBoldLine( "Extension is installed under  " )
			.greenBoldLine( "Extension > Applications > Installed > H2 " )
		  .greenBoldLine( "==================================================" )
		  .line().toConsole();
		}
 		if(confirm("Sound good? [y/n]")){
 			//var tempDir=createUUID();

 			print.greenline( "========= Installing CFWheels.........." ).toConsole();

			// Note: deliberately not using cache due to https://github.com/cfwheels/cfwheels/issues/652
			//command( 'artifacts remove cfwheels --force' ).run();

			// Install into a temp directory to prevent overwriting other cfwheels named folders
			command( 'install ').params(id=setVersion, directory=appName).run();

			print.greenline( "========= Navigating to new application..." ).toConsole();
				command('cd #appName#').run();

		 		print.greenline( "========= Creating config/app.cfm" ).toConsole();
		 		appContent = replaceNoCase( appContent, "|appName|", appName, 'all' );

		 		 // Create h2 embedded db by adding an application.cfc level datasource
			    if(allowH2Creation && createH2Embedded){
		 			print.greenline( "========= Creating Development Database").toConsole();
			 		var datadirectory=fileSystemUtil.resolvePath("db/h2/");

		 			if(!directoryExists(datadirectory)){
		 				print.greenline( "========= Creating /db/h2/ path ").toConsole();
		 				directoryCreate(datadirectory);
		 			}

		 			print.greenline( "========= Adding Datasource to onApplicationStart").toConsole();
		 			var datasourceConfig="this.datasources['#datasourceName#'] = {
					  class: 'org.h2.Driver'
					, connectionString: 'jdbc:h2:file:##expandPath('/db/h2/')###datasourceName#;MODE=MySQL'
					,  username = 'sa'
					};";

			 		appContent = replaceNoCase( appContent, '// CLI-Appends-Here', datasourceConfig & cr & '// CLI-Appends-Here', 'one');

			 	}
			 	file action='write' file='#fileSystemUtil.resolvePath("config/app.cfm")#' mode ='777' output='#trim(appContent)#';

	 		print.greenline( "========= Creating config/settings.cfm" ).toConsole();
		 		settingsContent = replaceNoCase( settingsContent, "|reloadPassword|", trim(reloadPassword), 'all' );
		 		settingsContent = replaceNoCase( settingsContent, "|datasourceName|", datasourceName, 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("config/settings.cfm")#' mode ='777' output='#trim(settingsContent)#';

	 		print.greenline( "========= Adding altered config/routes.cfm" ).toConsole();
	 			file action='write' file='#fileSystemUtil.resolvePath("config/routes.cfm")#' mode ='777' output='#trim(routesContent)#';

			// Make server.json server name unique to this app: assumes lucee by default
	 		print.greenline( "========= Creating default server.json" ).toConsole();
 			var serverJSON	        = fileRead( helpers.getTemplate('/ServerJSON.txt' ) );
		 		serverJSON = replaceNoCase( serverJSON, "|appName|", trim(appName), 'all' );
		 		serverJSON = replaceNoCase( serverJSON, "|setEngine|", setEngine, 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("server.json")#' mode ='777' output='#trim(serverJSON)#';
		 	// Copy urlrewrite.xml
		 	command( 'cp' )
				    .params( path=expandPath("/cfwheels-cli/templates/urlrewrite.xml"), newPath=fileSystemUtil.resolvePath("urlrewrite.xml"))
				    .run();
	 		// Definitely refactor this into some sort of templating system?
	 		if(useBootstrap3){
	 		print.greenline( "========= Installing Bootstrap3 Settings").toConsole();
	 		 	// Replace Default Template with something more sensible
	 		 	var bsLayout=fileRead( helpers.getTemplate('/bootstrap3/layout.cfm' ) );
	 		 		bsLayout = replaceNoCase( bsLayout, "|appName|", appName, 'all' );
	 		 		file action='write' file='#fileSystemUtil.resolvePath("views/layout.cfm")#' mode ='777' output='#trim(bsLayout)#';
	 		 	// Add Bootstrap 3 default form settings
	 		 	var bsSettings=fileRead( helpers.getTemplate('/bootstrap3/settings.cfm' ) );
				settingsContent = replaceNoCase( settingsContent, '// CLI-Appends-Here', bsSettings & cr & '// CLI-Appends-Here', 'one');
				file action='write' file='#fileSystemUtil.resolvePath("config/settings.cfm")#' mode ='777' output='#trim(settingsContent)#';

	 		 	// New Flashwrapper Plugin needed - install it via Forgebox
	 		 	command( 'install cfwheels-flashmessages-bootstrap' ).run();
	 		print.line();
		    }



			command('ls').run();
			print.line()
			print.greenBoldLine( "========= All Done! =============================" )
				 .greenBoldLine( "Your app has been successfully created. Type   " )
				 .greenBoldLine( "'start' to start a server here.                " )
				 .greenBoldLine( "                                               " );
			if(!createH2Embedded){
			print.greenBoldLine( "Don't forget to add your datasource to either  " )
				 .greenBoldLine( "/lucee/admin/server.cfm OR                     " )
				 .greenBoldLine( "/CFIDE/administrator/index.cfm                 " )
				 .greenBoldLine( "                                               " );
			}
			print.greenBoldLine( "Once you've started a local server, we can get " )
				 .greenBoldLine( "going with scaffolding and other awesome things" )
				 .greenBoldLine( "==================================================" )
				 .line();
		} else {
			error("OK, another time then. *sobs*");
		}


	}

}
