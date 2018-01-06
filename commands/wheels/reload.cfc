/**
 * Reloads a wheels app: will ask for your reload password (and optional mode, we assume design)
 * Will only work on a running server
 *
 * {code:bash}
 * wheels reload
 * {code}
 *
 * {code:bash}
 * wheels reload mode="production"
 * {code}
 **/
component aliases='wheels r'  extends="base"  {

	/**
	 * @mode.hint Mode to switch to
	 * @mode.options design,development,testing,maintenance,production
	 * @password The reload password
	 **/
	function run(string mode="design", required string password) {

  		var serverDetails = $getServerInfo();

  		getURL = serverDetails.serverURL &
  			"/rewrite.cfm?reload=#mode#&password=#password#";
  		var loc = new Http( url=getURL ).send().getPrefix();
  		print.line("Reload Request sent");
	}

}
