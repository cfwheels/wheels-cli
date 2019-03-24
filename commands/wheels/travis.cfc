/**
* Run Core Wheels Framework Tests (travis) | Internal Use Only
*
* {code:bash}
* wheels travis url=blah
* {code}
*
**/
component extends="base" {

	/**
	* @url.hint Absolute Path to test json runner, i.e http://127.0.0.1:58432
	*/
	function run(
	  	required string server,
	  	string runner = "?controller=wheels&action=wheels&view=tests&type=core&format=json",
	  	boolean debug = false
	) {

	  	var hiddenCount = 0;
	  	var resultset = "";
	  	var uri = arguments.server & arguments.runner;
	  	var debug = arguments.debug;

	  	print.greenBoldLine( "================Core Travis Tests =======================" ).toConsole();
		print.boldCyanLine( "Executing tests, please wait..." )
			.blinkingRed( "Please wait...")
			.printLine()
			.toConsole();
		try{
			var results = new Http( url=uri ).send().getPrefix();
		} catch( any e ){
			return error( 'Error executing tests: #CR# #e.message##CR##e.detail#' );
		}
		if(isJson(results.filecontent)){

			var result = deserializeJSON(results.filecontent);

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
				 		 	 .line("#Formatter.HTML2ANSI(r.message)#")
				 		 	 .line("----------------------------------------------------")
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

		} else {
			print.line(Formatter.HTML2ANSI(results.filecontent));
		}
	}

}
