/**
 * Provides information about the CLI module, and also any identified wheels version
 *
 * {code:bash}
 * wheels info
 * {code}
 **/
component  extends="base"  {

	/**
	 *
	 **/
	function run(  ) {
		var current={
			directory		=getCWD(),
			moduleRoot		=expandPath("../modules/cfwheels-cli/"),
			wheelsVersion	=$getWheelsVersion()
		};


		print.greenBoldLine( "================CFWheels CLI =======================" )
			.greenBoldLine( "Version 0.1.4" )
			.greenBoldLine( "This is highly experimental, and will probably fry your brain" )
			.greenBoldLine( "====================================================" )
			.greenBoldLine( "= Current Working Directory: #current.directory#")
			.greenBoldLine( "= CommandBox Module Root: #current.moduleRoot#")
			.greenBoldLine( "= Current CFWheels Version in this directory: #current.wheelsVersion#")
			.greenBoldLine( "====================================================" );
	}

}
