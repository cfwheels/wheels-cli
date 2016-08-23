/**
 * Base CFC: Everything extends from here.
 **/
component excludeFromHelp=true {
	property name='serverService' inject='ServerService';
	property name='Formatter'     inject='Formatter';
	property name='Helpers'       inject='helpers@wheels';
	property name='packageService' inject='packageService';

//=====================================================================
//= 	Scaffolding
//=====================================================================

	// Try and get wheels version from box.json
	string function $getWheelsVersion(){
		var local.boxJSON = packageService.readPackageDescriptorRaw( getCWD() );
		return local.boxJSON.version ?: "0.0.0";
	}

	// Compare against current wheels version
	// scope can be one of major/minor/patch
	boolean function $isWheelsVersion(required any version, string scope="major"){
		// Assume a string like 2, or 2.0, or 2.0.1, or 1.x
		var currentversion=listToArray($getWheelsVersion(), ".");
		var compareversion=listToArray(arguments.version, ".");
		if(arguments.scope == "major"){
			if(compareversion[1] == currentversion[1]){
				return true;
			}
		}
		if(arguments.scope == "minor"){
			if(compareversion[2] == currentversion[2]){
				return true;
			}
		}
		if(arguments.scope == "patch"){
			if(compareversion[3] == currentversion[3]){
				return true;
			}
		}
		return false;
	}

	// Replace default objectNames
	string function $replaceDefaultObjectNames(required string content,required struct obj){
		local.rv=arguments.content;
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNameSingular|', obj.objectNameSingular, 'all' );
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNamePlural|',   obj.objectNamePlural, 'all' );
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNameSingularC|', obj.objectNameSingularC, 'all' );
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNamePluralC|',   obj.objectNamePluralC, 'all' );
		return local.rv;
	}

    // Inject CLI content into template
    function $injectIntoView(required struct objectNames, required string property, required string type, string action="input"){
        if(arguments.action EQ "input"){
            local.target=fileSystemUtil.resolvePath("views/#objectNames.objectNamePlural#/_form.cfm");
            local.inject=$generateFormField(objectname=objectNames.objectNameSingular, property=arguments.property, type=arguments.type);
        } else if(arguments.action EQ "output"){
            local.target=fileSystemUtil.resolvePath("views/#objectNames.objectNamePlural#/show.cfm");
            local.inject=$generateOutputField(objectname=objectNames.objectNameSingular, property=arguments.property, type=arguments.type);
        }
        local.content=fileRead(local.target);
        // inject into position CLI-Appends-Here
        local.content = replaceNoCase(local.content, '<!--- CLI-Appends-Here --->', local.inject & cr & '<!--- CLI-Appends-Here --->', 'all');
        // Replace tokens with ## tags
        local.content = Replace(local.content, "~[~", "##", "all");
        local.content = Replace(local.content, "~]~", "##", "all");
        // Finally write out the file
        file action='write' file='#local.target#' mode ='777' output='#trim(local.content)#';
    }

    // Returns contents for a default (non crud) action
    function $returnAction(required string name, string hint=""){
    	local={
    		templateDirectory = helpers.getTemplateDirectory(),
    		name = trim(arguments.name),
    		hint = trim(arguments.hint),
    		rv=""
    	}
    	local.rv = fileRead( local.templateDirectory & '/ActionContent.txt' );

    	if(len(local.hint) == 0){
    		local.hint = local.name;
    	}

		local.rv = replaceNoCase( local.rv, '|ActionHint|', local.hint, 'all' );
		local.rv = replaceNoCase( local.rv, '|Action|', local.name, 'all' ) & cr & cr;
        return local.rv;
    }


	// Default output for show.cfm:
 	function $generateOutputField(required string objectName, required string property, required string type){

		local.rv="<p><strong>#helpers.capitalize(property)#</strong><br />~[~";

		switch(type){
			// Return a checkbox
			case "boolean":
				local.rv&="yesNoFormat(#objectName#.#property#)";
			break;
			// Return a calendar
			case "date":
				local.rv&="dateFormat(#objectName#.#property#)";
			break;
			// Return a time picker
			case "time":
				local.rv&="timeFormat(#objectName#.#property#)";
			break;
			// Return a calendar and time picker
			case "datetime":
			case "timestamp":
				local.rv&="dateTimeFormat(#objectName#.#property#)";
			break;
			// Return a text field if everything fails, i.e assume string
			// Let's escape the output to be safe
			default:
				local.rv&="xmlFormat(#objectName#.#property#)";
			break;
		}
		local.rv&="~]~</p>";
		return local.rv;
 	}

 	function $generateFormField(required string objectName, required string property, required string type){
		local.rv="";
		switch(type){
			// Return a checkbox
			case "boolean":
				local.rv="checkbox(objectName='#objectName#', property='#property#')";
			break;
			// Return a textarea
			case "text":
				local.rv="textArea(objectName='#objectName#', property='#property#')";
			break;
			// Return a calendar
			case "date":
				local.rv="dateSelect(objectName='#objectName#', property='#property#')";
			break;
			// Return a time picker
			case "time":
				local.rv="timeSelect(objectName='#objectName#', property='#property#')";
			break;
			// Return a calendar and time picker
			case "datetime":
			case "timestamp":
				local.rv="dateTimeSelect(objectName='#objectName#', property='#property#')";
			break;
			// Return a text field if everything fails, i.e assume string
			default:
				local.rv="textField(objectName='#objectName#', property='#property#')";
			break;
		}
		// We need to make these rather unique incase the view file has *any* pre-existing
		local.rv = "~[~" & local.rv & "~]~";
		return local.rv;
 	}

//=====================================================================
//= 	DB Migrate
//=====================================================================
	// Before we can even think about using DBmigrate, we've got to check a few things
	function $preConnectionCheck(){
		var serverJSON=fileSystemUtil.resolvePath("server.json");
 			if(!fileExists(serverJSON)){
 				error("We really need a server.json with a port number and a servername. We can't seem to find it.");
 			}
		// Wheels folder in expected place? (just a good check to see if the user has actually installed wheels...)
 		var wheelsFolder=fileSystemUtil.resolvePath("wheels");
 			if(!directoryExists(wheelsFolder)){
 				error("We can't find your wheels folder. Check you have installed CFWheels, and you're running this from the site root: If you've not started an app yet, try wheels new myApp");
 			}
		// Plugins in place?
 		var pluginsFolder=fileSystemUtil.resolvePath("plugins");
 			if(!directoryExists(wheelsFolder)){
 				error("We can't find your plugins folder. Check you have installed CFWheels, and you're running this from the site root.");
 			}
 		// Wheels 1.x requires dbmigrate plugin
 		// Wheels 2.x has dbmigrate + dbmigratebridge equivalents in core
 		if($isWheelsVersion(1, "major")){
 			var DBMigratePluginLocation=fileSystemUtil.resolvePath("plugins/dbmigrate");
 			if(!directoryExists(DBMigratePluginLocation)){
 				error("We can't find your plugins/dbmigrate folder? Please check the plugin is successfully installed; if you've not started the server using server start for the first time, this folder may not be created yet.");
 			}
			var DBMigrateBridgePluginLocation=fileSystemUtil.resolvePath("plugins/dbmigratebridge");
 			if(!directoryExists(DBMigrateBridgePluginLocation)){
 				error("We can't find your plugins/dbmigratebridge folder? Please check the plugin is successfully installed;  if you've not started the server using server start for the first time, this folder may not be created yet.");
 			}
 		}

	}

	// Get information about the currently running server so we can send commmands
	function $getServerInfo(){
		var serverDetails = serverService.resolveServerDetails( serverProps={ name=listLast( getCWD(), '/\' ) } );
  		var loc ={
  			host              = serverDetails.serverInfo.host,
  			port              = serverDetails.serverInfo.port,
  		};
  		loc.serverURL		  = "http://" & loc.host & ":" & loc.port
	  	return loc;
	}

	// Construct remote URL depending on wheels version
	string function $getBridgeURL() {
		var serverInfo=$getServerInfo();
		var geturl=serverInfo.serverUrl;
		// Wheels 1.x requires dbmigratebridge plugin
  		if($isWheelsVersion(1, "major")){
  			getURL &= "/index.cfm?controller=wheels&action=wheels&view=plugins&name=dbmigratebridge";
  		} else if($isWheelsVersion(2, "major")){
  			// Wheels 2.x has dbmigrate + dbmigratebridge equivalents in core
  			getURL &= "/index.cfm?controller=wheels&action=wheels&view=cli";
  		} else {
  			error("We're not sure which major version of wheels you're on... You need to create a box.json file in the site root with a version number");
  		}
  		return geturl;
	}

	// Basically sends a command
	function $sendToCliCommand(string urlstring=""){

		targetURL=$getBridgeURL() & arguments.urlstring;

		$preConnectionCheck();

		loc = new Http( url=targetURL ).send().getPrefix();
		if(isJson(loc.filecontent)){
  			loc.result=deserializeJSON(loc.filecontent);
  			if(loc.result.success){
  				if(structKeyExists(loc.result, "MESSAGE")){
					return loc.result.message;
				} else {
					return loc.result;
				}
  			} else {
  				error(loc.result.messages);
  			}
  		} else {
  			print.line(helpers.stripTags(Formatter.unescapeHTML(loc.filecontent)));
  			error("Error returned from DBMigrate Bridge");
  		}
	}

  	// Create the physical migration cfc in /db/migrate/
	function $createMigrationFile(required string name, required string action, required string content){
			var directory1=fileSystemUtil.resolvePath("db/");
			var directory2=fileSystemUtil.resolvePath("db/migrate/");
			if(!directoryExists(directory1)){
				directoryCreate(directory1);
			}
			if(!directoryExists(directory2)){
				directoryCreate(directory2);
			}
			content=replaceNoCase(content, "|DBMigrateExtends|", "plugins.dbmigrate.Migration", "all");
			content=replaceNoCase(content, "|DBMigrateDescription|", "CLI #action#_#name#", "all");
			var fileName=dateformat(now(),'yyyymmdd') & timeformat(now(),'HHMMSS') & "_cli_#action#_" & name & ".cfc";
			var filePath=directory2 & "/" & fileName;
			file action='write' file='#filePath#' mode ='777' output='#trim( content )#';
			print.line( 'Created #fileName#' );
	}



//=====================================================================
//= 	Testing Suite
//=====================================================================
/*
	*	In order to run any test suite, we need to know
		- Whether it's core/app/plugin: this is dictated by command; i.e wheels test core
		We then need to know the target server IP, port, and the location/query string of the tests
		We're always going to want to return JSON.

	  		wheels test core 	[serverName] [reload] [debug]
	  		wheels test app 	[serverName] [reload] [debug]
	  		wheels test plugin 	[pluginName] [serverName] [debug]
	*/
	  function $buildTestSuite(
	  	required string type,
	  	string servername="",
	  	boolean reload=true,
	  	boolean debug=false
	  ){
	  		// Get Server Details from CB
	  		var serverDetails = serverService.resolveServerDetails( serverProps={ name=arguments.servername } );
	  		// Massage into something more managable
	  		var loc ={
	  			type              = arguments.type,
	  			servername        = arguments.servername,
	  			serverdefaultName = serverDetails.defaultName,
	  			configFile        = serverDetails.defaultServerConfigFile,
	  			host              = serverDetails.serverInfo.host,
	  			port              = serverDetails.serverInfo.port,
	  			debug             = arguments.debug,
	  			reload            = arguments.reload
	  		};

	  		// TODO: Check for existance of actual tests: if not running master branch, /wheels/tests/ won't exist
	  		// Also, /tests/ may well not exist for an app.
	  		switch(loc.type){
	  			case "app":
	  			// Check /tests/
	  			break;
	  			case "core":
	  			// Check /wheels/tests/
	  			break;
	  			case "plugin":
	  			// Check /plugins/[pluginName]/tests/
	  			break;
	  		}

	  		// Construct Test URL
	  		// Always force JSON as return format
	  		// TODO: Plugins
	  		loc.testurl = "http://" & loc.host & ":" & loc.port
	  					   & "/" & "index.cfm?controller=wheels&action=wheels&view=tests"
	  					   & "&type=#loc.type#"
	  					   & "&format=json"
	  					   & "&reload=#loc.reload#";
	  		return loc;
	  }

	// Small Debug helper
	function $outputSuiteVariables(suite){
		print.line("Type:       #suite.type#");
		print.line("Server:     #suite.servername#");
		print.line("Name:       #suite.serverdefaultName#");
		print.line("Config:     #suite.configFile#");
		print.line("Host:       #suite.host#");
		print.line("Port:       #suite.port#");
		print.line("URL:        #suite.testurl#");
		print.line("Debug:      #suite.debug#");
		print.line("Reload:     #suite.reload#");
	}

	// Run baby run
	function $runTestSuite(struct suite){

	  	print.greenBoldLine( "================#ucase(suite.type)# Tests =======================" ).toConsole();

		// Advice we are running
		print.boldCyanLine( "Executing tests, please wait..." )
			.blinkingRed( "Please wait...")
			.printLine()
			.toConsole();

		try{
			var results = new Http( url=suite.testURL ).send().getPrefix();
		} catch( any e ){
			return error( 'Error executing tests: #CR# #e.message##CR##e.detail#' );
		}

		// If the URL is wrong, or the server dies, this should trigger
		if(!isJson(results.filecontent)){
			error( 'Result from #suite.testURL# isnt JSON?');
		}
		var result  = deserializeJSON(results.filecontent);

		$outputTestResults(result, suite.debug);
	}

	// Output pls
	function $outputTestResults(result, debug){
	  	var hiddenCount = 0;

		if(result.ok){
			print.greenBoldLine( "================ Tests Complete: All Good! =============" );
		} else {
			print.redBoldLine( "================ Tests Complete: Failures! =============" );
		}

		print.boldLine( "================ Results: =======================" );
			 for(r in result.results){
			 	if(r.status != "Success"){
			 		print.boldLine("Test Case:")
			 			 .boldRedLine("       #r.cleantestcase#:")
			 		 	 .boldLine("Test Name: :")
			 			 .boldRedLine("       #r.testname#:")
			 		 	 .boldLine("Message:")
			 		 	 .boldRedLine("       #r.message#")
			 		 	 .boldRedLine("----------------------------------------------------")
			 		 	 .line();
		 		} else {
		 			if(debug){
		 				print.greenline("#r.cleantestcase#: #r.testname# :#r.time#");
	 				} else {
		 				hiddenCount++;
	 				}
		 		}
			 }
		print.boldLine( "Output from #hiddenCount# tests hidden");
		print.Line("================ Summary: =======================" )
			 .line("= Tests: #result.numtests#")
			 .line("= Cases: #result.numcases#")
			 .line("= Errors: #result.numerrors#")
			 .line("= Failures: #result.numfailures#")
			 .line("= Successes: #result.numsuccesses#")
			 .Line("==================================================" );
 	}
}