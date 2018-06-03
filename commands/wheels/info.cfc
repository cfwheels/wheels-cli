/**
 * Provides information about the CLI module, and also any identified wheels version
 *
 * {code:bash}
 * wheels info
 * {code}
 **/
component  extends="base"  {

	property name='fileSystem' inject='fileSystem';
	/**
	 *
	 **/
	function run(  ) {
		var current={
			directory		= getCWD(),
			moduleRoot		= expandPath("/cfwheels-cli/"),
			wheelsVersion	= $getWheelsVersion()
		};
		print.redLine(" ,-----.,------.,--.   ,--.,--.                   ,--.            ,-----.,--.   ,--. ")
			.redLine("'  .--./|  .---'|  |   |  ||  ,---.  ,---.  ,---. |  | ,---.     '  .--./|  |   |  | ")
			.redLine("|  |    |  `--, |  |.'.|  ||  .-.  || .-. :| .-. :|  |(  .-'     |  |    |  |   |  | ")
			.redLine("'  '--'\|  |`   |   ,'.   ||  | |  |\   --.\   --.|  |.-'  `)    '  '--'\|  '--.|  | ")
			.redLine(" `-----'`--'    '--'   '--'`--' `--' `----' `----'`--'`----'      `-----'`-----'`--' ")
			.yellowBoldLine( "================CFWheels CLI =======================" )
			.yellowBoldLine( "This is highly experimental, and will probably fry your brain" )
			.yellowBoldLine( "====================================================" )
			.yellowBoldLine( "= Current Working Directory: #current.directory#")
			.yellowBoldLine( "= CommandBox Module Root: #current.moduleRoot#")
			.yellowBoldLine( "= Current CFWheels Version in this directory: #current.wheelsVersion#")
			.yellowBoldLine( "====================================================" );
	}

}
