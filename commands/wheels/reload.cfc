/**
 * Reload a wheels app
 **/
component aliases='wheels r'  extends="base"  {

	/**
	 *
	 **/
	function run(string mode="design", required string password) {

  		var serverDetails = $getServerInfo();

  		getURL = serverDetails.serverURL &
  			"/index.cfm?reload=#mode#&password=#password#";
  		var loc = new Http( url=getURL ).send().getPrefix();
  		print.line("Reload Request sent");
	}

}