/**
 * Shows Forgebox Plugins List for CFWheels
 *
 * {code:bash}
 * wheels plugins list
 * {code}
 **/
component aliases="wheels plugin list" extends="base"  {

	/**
	 *
	 **/
	function run(  ) {
		print.greenBoldLine("================ CFWheels Plugins From Forgebox ======================")
		command('forgebox show').params(type="cfwheels-plugins").run();
		print.greenBoldLine("======================================================================");
	}

}
