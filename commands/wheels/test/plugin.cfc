/**
* Run Wheels Plugin Tests: Not finished yet.
*
* {code:bash}
* wheels test plugin [pluginName] [servername] [reload] [debug]
* {code} 
* 
**/
component extends="base" {
	property name='serverService' inject='ServerService';

	/**
	* @pluginName.hint Name of plugin to test
	* @servername.hint Choose alternative server if not default
	* @reload.hint Force Reload 
	* @debug.hint Output passing tests as well as failing ones 
	*/
	function run(required string pluginName, string servername="", boolean reload=true, boolean debug=false) { 
	 	var suite=$buildTestSuite("plugin", arguments.servername, arguments.reload, arguments.debug);
				  $outputSuiteVariables(suite);
				  $runTestSuite(suite);
	}

}