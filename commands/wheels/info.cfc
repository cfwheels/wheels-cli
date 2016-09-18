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
			wheelsVersion	=$getWheelsVersion(),
			isWheels1		=$isWheelsVersion(1, 'major'),
			isWheels2		=$isWheelsVersion(2, 'major')
		};


		print.greenBoldLine( "================CFWheels CLI =======================" )
			.greenBoldLine( "Version 0.1.1" )
			.greenBoldLine( "This is highly experimental, and will probably fry your brain" )
			.greenBoldLine( "====================================================" )
			.greenBoldLine( "= Current Working Directory: #current.directory#")
			.greenBoldLine( "= CommandBox Module Root: #current.moduleRoot#")
			.greenBoldLine( "= Current CFWheels Version in this directory: #current.wheelsVersion#")
			.greenBoldLine( "= Use 1.x markup/routes = #current.isWheels1#")
			.greenBoldLine( "= Use 2.x markup/routes = #current.isWheels2#")
			.greenBoldLine( "====================================================" );
	}

}
