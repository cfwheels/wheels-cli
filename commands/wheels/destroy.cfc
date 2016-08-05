/**
 * Destroy: kill an object and it's associated DB transactions and view/controller/model files
 * wheels destroy user
 **/
component extends="base"  {
	 

	/**
	 * @name.hint Name of object to destroy 
	 **/
	function run(required string name) { 

		var obj            = helpers.getNameVariants(arguments.name);
		var modelFile      = fileSystemUtil.resolvePath("models/#obj.objectNameSingularC#.cfc");
		var controllerFile = fileSystemUtil.resolvePath("controllers/#obj.objectNamePluralC#.cfc");
		var viewFolder     = fileSystemUtil.resolvePath("views/#obj.objectNamePlural#/");

		print.redBoldLine("================================================")
			 .redBoldLine("= Watch Out!                                   =")
			 .redBoldLine("================================================")
			 .line("This will delete the associated database table '#obj.objectNamePlural#', and")
			 .line("the following files and directories:")
			 .line()
			 .line("#modelFile#")
			 .line("#controllerFile#")
			 .line("#viewFolder#") 
			 .line();

		if(confirm("Are you sure? [y/n]")){ 
			command('delete').params(path=modelFile, force=true).run();  
			command('delete').params(path=controllerFile, force=true).run();  
			command('delete').params(path=viewFolder, force=true, recurse=true).run();  

			print.greenline( "Migrating DB" ).toConsole();
			command('wheels dbmigrate remove table').params(name=obj.objectNamePlural).run(); 
			command('wheels dbmigrate latest').run();
			print.line();
		}

	}

}