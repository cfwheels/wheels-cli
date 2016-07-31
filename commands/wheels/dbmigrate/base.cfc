/**
 * Test Suite Runner
 **/
component excludeFromHelp=true { 
	property name='serverService' inject='ServerService';
	property name='Formatter' inject='Formatter';  
	property name='Helpers' inject='helpers@wheels'; 

	// Before we can even think about using DBmigrate, we've got to check a few things
	function $preConnectionCheck(){
		// Wheels folder in expected place? (just a good check to see if the user has actually installed wheels...)
 		var wheelsFolder=fileSystemUtil.resolvePath("/wheels");
 			if(!directoryExists(wheelsFolder)){
 				error("We can't find your wheels folder. Check you have installed CFWheels, and you're running this from the site root: If you've not started an app yet, try wheels new myApp");
 			}
		// Plugins in place?
 		var pluginsFolder=fileSystemUtil.resolvePath("/plugins");
 			if(!directoryExists(wheelsFolder)){
 				error("We can't find your plugins folder. Check you have installed CFWheels, and you're running this from the site root.");
 			}
 		var DBMigratePluginLocation=fileSystemUtil.resolvePath("/plugins/dbmigrate");
 			if(!directoryExists(DBMigratePluginLocation)){
 				error("We can't find your plugins/dbmigrate folder? Please check the plugin is successfully installed");
 			}
 		var DBMigrateBridgePluginLocation=fileSystemUtil.resolvePath("/plugins/dbmigratebridge");
 			if(!directoryExists(DBMigrateBridgePluginLocation)){
 				error("We can't find your plugins/dbmigratebridge folder? Please check the plugin is successfully installed");
 			}
	} 

	//function $remotePost(struct postcontents){
	//	$preConnectionCheck()
	//	var serverDetails = $getServerInfo(); 
	//	var postURL = "http://" & serverDetails.host & ":" & serverDetails.port 
  	//				   & "/" & "index.cfm?controller=wheels&action=wheels&view=plugins&name=dbmigrate"; 
	//	var httpService = new http();;
	//		httpService.setUrl( postURL );
	//		httpService.setMethod( "POST" );
	//		httpService.setCharset( "utf-8" ); 
	//		for (field in postcontents){
	//			httpService.addParam(type="formfield", name="#field#", value="#postcontents[field]#"); 
	//		} 
	//		httpResponse = httpService.send().getPrefix();
	//	var result=deserializeJSON(httpResponse.fileContent);
	//		print.line(result.message);
	//}

	function $getServerInfo(){
		$preConnectionCheck()
		var serverDetails = serverService.resolveServerDetails( serverProps={ name=listLast( getCWD(), '/\' ) } ); 
  		var loc ={  
  			host              = serverDetails.serverInfo.host,
  			port              = serverDetails.serverInfo.port,
  		}; 
  		loc.serverURL		  = "http://" & loc.host & ":" & loc.port
	  	return loc;
	}

	function $getDBMigrateInfo(){ 
		$preConnectionCheck()
  		var serverDetails = $getServerInfo();
  		var getURL = serverDetails.serverURL & "/index.cfm?controller=wheels&action=wheels&view=plugins&name=dbmigratebridge";
  		var loc = new Http( url=getURL ).send().getPrefix(); 
		if(isJson(loc.filecontent)){
  			loc.result=deserializeJSON(loc.filecontent);
  			if(loc.result.success){  
					return loc.result;  
  			} else {
  				error(loc.result.messages);
  			}
  		} else {
  			print.line(helpers.stripTags(Formatter.unescapeHTML(loc.filecontent)));
  			error("Error returned from DBMigrate Bridge"); 
  		} 
	}	 
	function $getRemoteJSON(getURL){ 
		loc = new Http( url=getURL ).send().getPrefix(); 
		if(isJson(loc.filecontent)){
  			loc.result=deserializeJSON(loc.filecontent);
  			if(loc.result.success){
  				if(structKeyExists(loc.result, "MESSAGES")){
					return loc.result.messages; 
				} else {
					return loc.result; 
				}
  			} else {
  				error(loc.result.messages);
  			}
  		} else {
  			print.line(helpers.stripTags(Formatter.unescapeHTML(loc.filecontent)));
  			error("Error returned from DBMigrate Bridge"); 
  		}
	}



	function $createMigrationFile(required string name, required string action, required string content){  
			var directory1=fileSystemUtil.resolvePath("/db/"); 
			var directory2=fileSystemUtil.resolvePath("/db/migrate/"); 
			if(!directoryExists(directory1)){
				directoryCreate(directory1);
			}
			if(!directoryExists(directory2)){
				directoryCreate(directory2);
			}
			content=replaceNoCase(content, "|DBMigrateExtends|", "plugins.dbmigrate.Migration", "all");
			content=replaceNoCase(content, "|DBMigrateDescription|", "CLI #action#_#name#", "all"); 
			var fileName=dateformat(now(),'yyyymmdd') & timeformat(now(),'HHMMSS') & "_cli_#action#_" & name & ".cfc";
			var filePath=directory2 & "/" & fileName;
			file action='write' file='#filePath#' mode ='777' output='#trim( content )#';  
			print.line( 'Created #fileName#' );
	}


}