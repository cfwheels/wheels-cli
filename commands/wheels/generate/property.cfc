/**
 * I generate a dbmigration to add a property to an object
 * i.e, wheels generate property table columnName columnType
 * 
 *  
 **/
component {
	
	property name='helpers'		inject='helpers@wheels'; 
	/**
	 * @name.hint Table Name 
	 * @columnName.hint Name of Column
	 * @columnType.hint Type of Column
	 **/
	function run(
		required string name,
		required string columnName,
		string columnType="string" 
	){  
     
		command('wheels dbmigrate create column')
			.params(name=name,  columnName=columnName, columnType=columnType)
			.run();
		command('wheels dbmigrate latest').run(); 
	}


	 
}