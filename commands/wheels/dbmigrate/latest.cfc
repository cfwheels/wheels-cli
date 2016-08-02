/**
 * Migration to Latest
 **/
component  extends="../base"  {
	
	/**
	 * 
	 **/
	function run(  ) {
		var DBMigrateInfo=$getDBMigrateInfo(); 
		print.line("Updating Database Schema to Latest Version")
			 .line("Latest Version is #DBMigrateInfo.lastVersion#");
		command('wheels dbmigrate exec version=#DBMigrateInfo.lastVersion#').run();

	}

}