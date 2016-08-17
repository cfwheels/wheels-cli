/**
* Run Wheels Core Framework Tests: requires using the master git branch
*
* {code:bash}
* wheels test core [servername] [reload] [debug]
* {code}
*
**/
component extends="../base" {

	/**
	* @servername.hint Choose alternative server if not default
	* @reload.hint Force Reload
	* @debug.hint Output passing tests as well as failing ones
	*/
	function run(string servername="", boolean reload=true, boolean debug=false) {
	 	var suite=$buildTestSuite("core", arguments.servername, arguments.reload, arguments.debug);
				  $outputSuiteVariables(suite);
				  $runTestSuite(suite);
	}

}