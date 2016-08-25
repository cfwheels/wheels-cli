/**
 * Create a new CFWheels application called {name} in current working directory. Rename to {name} and navigate to after
 * Adds various configuration defaults and does some basic checks to make URL rewriting work out of the box.
 **/
component extends="base"  {


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
 		print.greenBoldLine( "========= We Need Some Information... ============" )
 			 .greenBoldLine( "= To get going, we're going to need to know a    =" )
 			 .greenBoldLine( "= NAME for your application. We recommend        =" )
 			 .greenBoldLine( "= something like myapp to start with             =" )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();
		var appName = ask( 'Please enter a name for your application: ' );
			appName=helpers.stripSpecialChars(appName);
		print.line();

		//---------------- Version
 		print.greenBoldLine( "========= Version?... ============================" )
 			 .greenBoldLine( "=   1) Stable (1.4.5) via Forgebox               =" )
 			 .greenBoldLine( "=   2) Master Branch (2.x) via Git               =" )
 			 .greenBoldLine( "=   3) DBMigrate Master Branch (2.x) via Git     =" )
 			 .greenBoldLine( "==================================================" )
 			 .line().toConsole();
		var version = ask( 'Please enter your preferred version [1-3]: ' );
			switch(version){
 				case 1:
 					setVersion="cfwheels";
 				break;
 				case 2:
 					setVersion="cfwheels/cfwheels";
 				break;
 				case 3:
 					setVersion="cfwheels/cfwheels##dbmigrate";
 				break;
 				default:
 					setVersion="cfwheels";
 				break;
 			}
		print.line();

 	    //---------------- Set reload Password
  		print.greenBoldLine( "========= And a 'Reload' Password ================" )
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



 	    //---------------- Set default server.json engine
  		print.greenBoldLine( "========= Default CFML Engine        =============" )
			 .greenBoldLine( "= Please select your preferred CFML engine for   =" )
			 .greenBoldLine( "= local development: you can always change it    =" )
			 .greenBoldLine( "= later!                                         =" )
			 .greenBoldLine( "=                                                =" )
			 .greenBoldLine( "=  1) lucee 4.5 (Commandbox default)             =" )
			 .greenBoldLine( "=  2) lucee 5.x                                  =" )
			 .greenBoldLine( "=  3) Adobe ColdFusion 10                        =" )
			 .greenBoldLine( "=  4) Adobe ColdFusion 11                        =" )
			 .greenBoldLine( "=  5) Adobe ColdFusion 2016                      =" )
			 .greenBoldLine( "==================================================" )
			 .line().toConsole();
 		var defaultEngine= ask('Please enter your preferred engine: [1-5] ');
 		var setEngine="lucee@5";
 		var allowH2Creation=false;
 			switch(defaultEngine){
 				case 1:
 					setEngine="lucee@4";
 					allowH2Creation=true;
 				break;
 				case 2:
 					setEngine="lucee@5";
 					allowH2Creation=true;
 				break;
 				case 3:
 					setEngine="adobe@10";
 				break;
 				case 4:
 					setEngine="adobe@11";
 				break;
 				case 5:
 					setEngine="adobe@2016";
 				break;
 			}
		print.line();

		//---------------- Test H2 Database?
		if(allowH2Creation){
			var createH2Embedded= confirm('As you are using Lucee, would you like to use an embedded H2 database for development? [y/n]');
			print.line();
		}


 		//---------------- This is just an idea at the moment really.
  		print.greenBoldLine( "========= Twitter Bootstrap ======================" ).toConsole();
		var useBootstrap3=false;
	    if(confirm("Would you like us to setup some default Bootstrap3 settings? [y/n]")){
	    	useBootstrap3 = true;
	    }

		print.greenBoldLine( "==================================================" ).toConsole();
		print.greenBoldLine( "Great! Think we all good to go. We're going to install CFWheels in '/#appName#/', with a reload password of '#reloadPassword#', and a datasource of '#datasourceName#'.").toConsole();
		if(allowH2Creation && createH2Embedded){
			print.greenBoldLine( "We're also going to try and setup an embedded H2 database for development mode." );
		}
 		if(confirm("Sound good? [y/n]")){
 			var tempDir=createUUID();

 			print.greenline( "========= Installing CFWheels.........." ).toConsole();

			// Note: deliberately not using cache due to https://github.com/cfwheels/cfwheels/issues/652
			command( 'artifacts remove cfwheels --force' ).run();

			// Install into a temp directory to prevent overwriting other cfwheels named folders
			command( 'install #setVersion# #tempDir#' ).run();

			print.greenline( "========= Moving Contents .........." ).toConsole();
				command('mv #tempDir#/CFWheels/ #appName#').run();

			print.greenline( "========= Removing Temp Dir........." ).toConsole();
				command('delete #tempDir# --recurse --force').run();

			print.greenline( "========= Navigating to new application..." ).toConsole();
				command('cd #appName#').run();

	 		print.greenline( "========= Creating config/app.cfm" ).toConsole();
		 		appContent = replaceNoCase( appContent, "|appName|", appName, 'all' );

		 		 // Create h2 embedded db by adding an application.cfc level datasource
			    if(allowH2Creation && createH2Embedded){
		 			print.greenline( "========= Creating Development Database").toConsole();
			 		var datadirectory=fileSystemUtil.resolvePath("/db/h2/");

		 			if(!directoryExists(datadirectory)){
		 				print.greenline( "========= Creating /db/h2/ path ").toConsole();
		 				directoryCreate(datadirectory);
		 			}

		 			print.greenline( "========= Adding Datasource to onApplicationStart").toConsole();
		 			var datasourceConfig="this.datasources['#datasourceName#'] = {
					  class: 'org.h2.Driver'
					, connectionString: 'jdbc:h2:mem:#datasourceName#;MODE=MySQL'
					,  username = 'sa'
					};";
			 		//var datasourceConfig="this.datasources['#datasourceName#'] = {
					//  class: 'org.h2.Driver'
					//, connectionString: 'jdbc:h2:#datadirectory#\#datasourceName#;MODE=MySQL'
					//};";
					/*
					// Added via CFWheels CLI
	this.name = "testapp";
	this.datasources.testapp = {
      class: 'org.hsqldb.jdbcDriver',
      bundleName:'org.h2',
      bundleVersion:'1.3.172',
      connectionString: 'jdbc:hsqldb:file:#getDirectoryFromPath(getCurrentTemplatePath())#/db/h2/'
    };*/
				/*	 this.datasources[datasourceName] = {
				        class: 'org.h2.Driver',
				        connectionString: 'jdbc:h2:mem:#datasourceName#;MODE=MySQL',
				        username = "sa"
				    };*/
			 		appContent = replaceNoCase( appContent, '// CLI-Appends-Here', datasourceConfig & cr & '// CLI-Appends-Here', 'one');

			 	}
			 	file action='write' file='#fileSystemUtil.resolvePath("config/app.cfm")#' mode ='777' output='#trim(appContent)#';

	 		print.greenline( "========= Creating config/settings.cfm" ).toConsole();
		 		settingsContent = replaceNoCase( settingsContent, "|reloadPassword|", trim(reloadPassword), 'all' );
		 		settingsContent = replaceNoCase( settingsContent, "|datasourceName|", datasourceName, 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("config/settings.cfm")#' mode ='777' output='#trim(settingsContent)#';

			// Make server.json server name unique to this app: assumes lucee by default
	 		print.greenline( "========= Creating default server.json" ).toConsole();
		 		serverJSON = replaceNoCase( serverJSON, "|appName|", trim(appName), 'all' );
		 		serverJSON = replaceNoCase( serverJSON, "|setEngine|", setEngine, 'all' );
		 		file action='write' file='#fileSystemUtil.resolvePath("server.json")#' mode ='777' output='#trim(serverJSON)#';

		 	// Version Specific changes
		 	if($isWheelsVersion(1, 'major')){

		 		print.greenline( "========= Adding urlrewrite.xml" ).toConsole();
	 				file action='write' file='#fileSystemUtil.resolvePath("urlrewrite.xml")#' mode ='777' output='#trim(urlRewriteContent)#';

		 		print.greenline( "========= Installing DBMigrate and DBMigratebridge Plugins").toConsole();
		 			command( 'cp' )
					    .params( path=expandPath("../modules/cfwheels-cli/plugins"), newPath='plugins', filter="*.zip" )
					    .run();
		 		print.line();

	 		}

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
	 		 	// Flashwrapper Plugin needed
	 		 	command( 'cp' )
				    .params( path=expandPath("../modules/cfwheels-cli/templates/bootstrap3/plugins/"), newPath='plugins', filter="*.zip" )
				    .run();
	 		print.line();
		    }



			command('ls').run();
			print.line()
			print.greenBoldLine( "========= All Done! =============================" )
				 .greenBoldLine( "= Your app has been successfully created. Type   =" )
				 .greenBoldLine( "= 'start' to start a server here.                =" )
				 .greenBoldLine( "=                                                =" );
			if(!createH2Embedded){
			print.greenBoldLine( "= Don't forget to add your datasource to either  =" )
				 .greenBoldLine( "= /lucee/admin/server.cfm OR                     =" )
				 .greenBoldLine( "= /CFIDE/administrator/index.cfm                 =" )
				 .greenBoldLine( "=                                                =" );
			}
			print.greenBoldLine( "= Once you've started a local server, we can get =" )
				 .greenBoldLine( "= going with scaffolding and other awesome things=" )
				 .greenBoldLine( "==================================================" )
				 .line();
		} else {
			error("OK, another time then. *sobs*");
		}


	}

}