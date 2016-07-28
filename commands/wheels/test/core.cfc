/**
* Run Wheels Core Framework Tests: requires using the master git branch 
*
* {code:bash}
* wheels test core [servername] [reload] [debug]
* {code} 
* 
**/
component extends="base" {
	property name='serverService' inject='ServerService';

	/**
	* @servername.hint Choose alternative server if not default
	*/
	function run(string servername="", boolean reload=true, boolean debug=false) { 
	 	var suite=$buildTestSuite("core", arguments.servername, arguments.reload, arguments.debug);
				  $outputSuiteVariables(suite);
				  $runTestSuite(suite);
	}

}
