/**
* Run Wheels Framework Tests
*
* {code:bash}
* wheels test [type] [servername] [reload] [debug]
* {code}
*
**/
component extends="base" {

	/**
	* @type.hint Either Core, App or the name of the plugin
	* @servername.hint Servername to run the tests against
	* @reload.hint Force Reload
	* @debug.hint Output passing tests as well as failing ones
	* @format.hint Force a specific return format for debug
	* @adapter.hint Attempt to override what dbadapter wheels uses
	*/
	function run(
		string type="app",
		string servername,
		boolean reload=true,
		boolean debug=false,
		string format="json",
		string adapter=""
	) {
	 	var suite=$buildTestSuite(argumentCollection=arguments);
				  $outputSuiteVariables(suite);
				  $runTestSuite(suite);
	}


//=====================================================================
//= 	Testing Suite
//=====================================================================
/*
	*	In order to run any test suite, we need to know
		- Whether it's core/app/plugin: this is dictated by command; i.e wheels test core
		We then need to know the target server IP, port, and the location/query string of the tests
		We're always going to want to return JSON.

	  		wheels test [type]	[serverName] [reload] [debug] [format]
	*/
	  function $buildTestSuite(
	  	required string type,
	  	string servername="",
	  	boolean reload=true,
	  	boolean debug=false,
	  	string format="json",
		string adapter=""
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
	  			format 			  = arguments.format,
	  			debug             = arguments.debug,
	  			reload            = arguments.reload,
	  			adapter 		  = arguments.adapter
	  		};

	  		// Construct Test URL
	  		// Always force JSON as return format
			if(loc.type eq 'app'){
				loc.testurl = "http://" & loc.host & ":" & loc.port
							   & "/" & "?controller=tests&action=runner&view=runner"
							   & "&type=#loc.type#"
							   & "&format=#loc.format#"
							   & "&reload=#loc.reload#";
			} else if(loc.type eq 'core'){
				loc.testurl = "http://" & loc.host & ":" & loc.port
							   & "/" & "?controller=wheels.tests_testbox&action=runner&view=runner"
							   & "&type=#loc.type#"
							   & "&format=#loc.format#"
							   & "&reload=#loc.reload#";
			}
	  		// Optional Adapter Override
	  		if(len(loc.adapter)){
	  			loc.testurl&="&adapter=#loc.adapter#"
	  		}
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
		print.line("Format:     #suite.format#");
		print.line("Adapter:    #suite.adapter#");
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
		if(isJson(results.filecontent)){
			$outputTestResults(deserializeJSON(results.filecontent), suite.debug);
		} else {
			print.line(Formatter.HTML2ANSI(results.filecontent));
		}
	}

	// Output pls
	function $outputTestResults(result, debug){
	  	var hiddenCount = 0;
		if(result.totalError == 0 && result.totalFail == 0){
			print.greenBoldLine( "================ Tests Complete: All Good! =============" );
		} else {
			print.redBoldLine( "================ Tests Complete: Failures! =============" );
		}

		print.boldLine( "================ Results: =======================" );
		for(bundle in result.bundleStats){
			for(suite in bundle.suiteStats){
				for(spec in suite.specStats){

					if(spec.status != "Passed" && spec.status != "Skipped"){
						print.boldLine("Test Bundle:")
							 .boldRedLine("       #bundle.name#:")
							 .boldLine("Test Suite: :")
							 .boldRedLine("       #suite.name#:")
							  .boldLine("Test Name: :")
							 .boldRedLine("       #spec.name#:")
							  .boldLine("Message:")
							  .line("#Formatter.HTML2ANSI(spec.failMessage)#")
							  .line("----------------------------------------------------")
							  .line();
					} else {
						if(debug){
							print.greenline("#bundle.name# #suite.name#: #spec.name# :#spec.totalDuration#");
						} else {
							hiddenCount++;
						}
					}
				}
			}
		}
		print.boldLine( "Output from #hiddenCount# tests hidden");
		print.Line("================ Summary: =======================" )
			 .line("= Bundles: #result.totalBundles#")
			 .line("= Suites: #result.totalSuites#")
			 .line("= Specs: #result.totalSpecs#")
			 .line("= Skipped: #result.totalSkipped#")
			 .line("= Errors: #result.totalError#")
			 .line("= Failures: #result.totalFail#")
			 .line("= Successes: #result.totalPass#")
			 .Line("==================================================" );
 	}

}
