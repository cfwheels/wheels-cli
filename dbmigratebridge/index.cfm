<cfinclude template="../dbmigrate/basefunctions.cfm">
<cfscript>
	dbmigrate = application.wheels.plugins.dbmigrate;
	try {
		"data"={
			"success"			= true,
			"datasource"     	= application.wheels.dataSourceName,
			"currentVersion" 	= dbmigrate.getCurrentMigrationVersion(),
			"databaseType"   	= $getDBType(),
			"migrations"     	= dbmigrate.getAvailableMigrations(),
			"lastVersion"    	= 0,
			"messages"			= "",
			"command"           = ""
		}
		if(ArrayLen(data.migrations)){
			data.lastVersion = data.migrations[ArrayLen(data.migrations)].version
		}  

		if(structKeyExists(params, "command")){
			data.command=params.command;
			switch(params.command){
				case "migrateTo":
				if(structKeyExists(params,"version")){ 
					data.message=dbmigrate.migrateTo(params.version);
				}
				break;
				case "info":
					data.message="Returning what I know..";
				break;
			}
		}
	} catch (any e){
		 data.success = false;
		 data.messages = e.message & ': ' & e.detail;
	}


</cfscript>
<cfcontent reset="true" type="application/json"><cfoutput>#serializeJSON(data)#</cfoutput><cfabort>
