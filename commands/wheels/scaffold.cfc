/**
 * Scaffold: create full CRUD for an object
 * wheels scaffold user
 **/
component extends="base"  {

	/**
	 * @name Name of object to scaffold
	 **/
	function run(required string name) {
		// Captialisation etc handled by sub components;
		var objectname=trim(lcase(helpers.stripSpecialChars(arguments.name)));

		print.yellowline( "Creating Model" ).toConsole();
			command('wheels generate model #objectname#').run();
		print.line();

		print.yellowline( "Creating Controller" ).toConsole();
			command('wheels generate controller #objectname# crud').run();
		print.line();

		print.yellowline( "Creating View Files" ).toConsole();
			command('wheels generate view #objectname# index crud/index').run();
			command('wheels generate view #objectname# show crud/show').run();
			command('wheels generate view #objectname# new crud/new').run();
			command('wheels generate view #objectname# edit crud/edit').run();
			command('wheels generate view #objectname# _form crud/_form').run();
		print.line();

		print.yellowline( "Migrating DB" ).toConsole();
		if(confirm("Would you like to migrate the database now? [y/n]")){
			command('wheels dbmigrate latest').run();
	    }
		print.line();
	}

}
