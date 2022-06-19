/**
 * Info
 **/
component aliases='wheels db info' extends="../base" {

	/**
	 *  Display DB Migrate info
	 **/
	function run(  ) {
		results = $sendToCliCommand();
		migrations = results.migrations.reverse();
		available = 0;
		print.yellowline( "+----------+------------------------------------------------------------------------+" );
		for (migration in migrations) {
			print.yellow("| ");
			if (migration.status == "") {
				available++;
				print.yellow( lJustify("",8) );
			} else {
				print.yellow( lJustify(migration.status,8) );
			}
			print.yellowLine( ' | ' & lJustify(migration.CFCFILE,70) & ' |');
		}
		print.yellowline( "+----------+------------------------------------------------------------------------+" );
		print.yellowline( "+-----------------------------------------+-----------------------------------------+" );
		print.yellow( "| Datasource: " & rJustify(results.datasource,27) & " | " );
		print.yellowLine( "Total Migrations: " & rJustify(arrayLen(results.migrations),21) & " |" );
		//print.yellowline( "+-----------------------------------------+-----------------------------------------+" );
		print.yellow( "| Database Type: " & rJustify(results.databaseType,24) & " | " );
		print.yellowLine( "Available Migrations: " & rJustify(available,17) & " |" );
		print.yellowline( "+-----------------------------------------+-----------------------------------------+" );
	}
}