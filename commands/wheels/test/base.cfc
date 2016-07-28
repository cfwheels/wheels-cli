/**
 * Test Suite Runner
 **/
component excludeFromHelp=true { 
	property name='serverService' inject='ServerService';
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

		$outputResults(result, suite.debug); 
	}

	// Output pls
	function $outputResults(result, debug){
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