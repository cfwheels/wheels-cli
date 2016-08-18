/**
 * Info
 **/
component  extends="base"  {
	property name='packageService' inject='packageService';

	/**
	 *
	 **/
	function run(  ) {
		var current={
			directory=getCWD(),
			moduleRoot=expandPath("../modules/cfwheels-cli/"),
			wheelsVersion=""
		};

		boxJSON = packageService.readPackageDescriptorRaw( current.directory );
		current.wheelsVersion = boxJSON.version ?: "Unknown - or we're not in a wheels app root";

		print.greenBoldLine( "================CFWheels CLI =======================" )
			.greenBoldLine( "Version 0.1.1" )
			.greenBoldLine( "This is highly experimental, and will probably fry your brain" )
			.greenBoldLine( "====================================================" )
			.greenBoldLine( "= Current Working Directory:")
			.greenBoldLine( "= #current.directory#")
			.greenBoldLine( "= ")
			.greenBoldLine( "= CommandBox Module Root:")
			.greenBoldLine( "= #current.moduleRoot#")
			.greenBoldLine( "= ")
			.greenBoldLine( "= Current CFWheels Version in this directory:")
			.greenBoldLine( "= #current.wheelsVersion#")
			.greenBoldLine( "= ")
			.greenBoldLine( "====================================================" );
	}

}