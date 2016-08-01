/**
 * Migrate to Version x
 * 
 * wheels dbmigrate exec 20160730115754
 * wheels dbmigrate exec 0
 **/
component  extends="base" { 
	
	/**
	 *  Migrate to specific version
	 * @version.hint Version to migrate to
	 **/
	function run(required string version) { 
		var loc={			
			version = arguments.version
		} 
  		var serverDetails = $getServerInfo();

  		getURL = serverDetails.serverURL & 
  			"/index.cfm?controller=wheels&action=wheels&view=plugins&name=dbmigratebridge&command=migrateTo&version=#loc.version#";
  		print.line("DBMigrateBridge > MigrateTo > #loc.version#");
		print.line(Formatter.formatJson($sendToDBMigrateBridge(getURL)));
	} 
}