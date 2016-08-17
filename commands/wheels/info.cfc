/**
 * Info
 **/
component  extends="base"  {

	/**
	 *
	 **/
	function run(  ) {
	print.greenBoldLine( "================CFWheels CLI =======================" )
		.greenBoldLine( "Version 0.1.1" )
		.greenBoldLine( "This is highly experimental, and will probably fry your brain" )
		.greenBoldLine( "====================================================" )
		.greenBoldLine( "= Current Working Directory:")
		.greenBoldLine( "= #getCWD()#")
		.greenBoldLine( "= ")
		.greenBoldLine( "= CommandBox Module Root:")
		.greenBoldLine( "= #expandPath("../modules/cfwheels-cli/")#")
		.greenBoldLine( "= ")
		.greenBoldLine( "====================================================" );
	}

}