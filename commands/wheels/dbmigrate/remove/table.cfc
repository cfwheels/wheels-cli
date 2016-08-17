/**
 * Create a migration CFC
 *
 **/
component aliases='wheels db remove table' extends="../../base"  {

	/**
	 * I create a migration file in /db/migrate
	 *
	 * Usage: wheels dbmigrate remove table [name]
	 **/
	function run(
		required string name ) {

		// Get Template
		var content=fileRead(helpers.getTemplate("dbmigrate/remove-table.txt"));

		// Changes here
		content=replaceNoCase(content, "|tableName|", "#name#", "all");

		// Make File
		 $createMigrationFile(name=lcase(trim(arguments.name)),	action="remove_table",	content=content);
	}
}