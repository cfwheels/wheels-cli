/**
 * Base CFC: Everything extends from here.
 **/
component excludeFromHelp=true {
	property name='serverService' inject='ServerService';
	property name='Formatter'     inject='Formatter';
	property name='Helpers'       inject='helpers@wheels';
	property name='packageService' inject='packageService';
	property name="ConfigService" inject="ConfigService";
	property name="JSONService" inject="JSONService";

//=====================================================================
//= 	Scaffolding
//=====================================================================

	// Try and get wheels version from box.json: otherwise, go ask.
	// alternative is to get via /wheels/events/onapplicationstart.cfm but that feels a bit hacky.
	// we could also test for the existence of /wheels/dbmigrate, but that only gives us the major version.
	string function $getWheelsVersion(){
		// First, look for a wheels folder..
		if(!directoryExists( fileSystemUtil.resolvePath("vendor/wheels") ) ){
			error("We're currently looking in #getCWD()#, but can't find a /wheels/ folder?");
		}
		if(fileExists(fileSystemUtil.resolvePath("box.json"))){
			local.boxJSON = packageService.readPackageDescriptorRaw( getCWD() );
			return local.boxJSON.version;
		} else if(fileExists(fileSystemUtil.resolvePath("vendor/wheels/events/onapplicationstart.cfm"))) { 
			var output = command( 'cd vendor\wheels' ).run( returnOutput=true );
			local.target=fileSystemUtil.resolvePath("app/events/onapplicationstart.cfm");
			local.content=fileRead(local.target);
			local.content=listFirst(mid(local.content, (find('application.$wheels.version',local.content)+31),20),'"');
			var output = command( 'cd ../../' ).run( returnOutput=true );
			return local.content;
		} else {
			print.line("You've not got a box.json, so we don't know which version of wheels this is.");
			print.line("We're currently looking in #getCWD()#");
			if(confirm("Would you like to try and create one? [y/n]")){
				local.version=ask("Which Version is it? Please enter your response in semVar format, i.e '1.4.5'");
				command('init').params(name="CFWHEELS", version=local.version, slugname="cfwheels").run();
				return local.version;
			} else {
				error("Ok, aborting");
			}
		}
	}

	// Compare against current wheels version
	// scope can be one of major/minor/patch
	boolean function $isWheelsVersion(required any version, string scope="major"){
		// Assume a string like 2, or 2.0, or 2.0.1, or 1.x
		var currentversion=listToArray($getWheelsVersion(), ".");
		var compareversion=listToArray(arguments.version, ".");
		if(arguments.scope == "major"){
			if(compareversion[1] == currentversion[1]){
				return true;
			}
		}
		if(arguments.scope == "minor"){
			if(compareversion[2] == currentversion[2]){
				return true;
			}
		}
		if(arguments.scope == "patch"){
			if(compareversion[3] == currentversion[3]){
				return true;
			}
		}
		return false;
	}

	// Replace default objectNames
	string function $replaceDefaultObjectNames(required string content,required struct obj){
		local.rv=arguments.content;
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNameSingular|', obj.objectNameSingular, 'all' );
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNamePlural|',   obj.objectNamePlural, 'all' );
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNameSingularC|', obj.objectNameSingularC, 'all' );
		local.rv 	 = replaceNoCase( local.rv, '|ObjectNamePluralC|',   obj.objectNamePluralC, 'all' );
		return local.rv;
	}

    // Inject CLI content into template
    function $injectIntoView(required struct objectNames, required string property, required string type, string action="input"){
        if(arguments.action EQ "input"){
            local.target=fileSystemUtil.resolvePath("app/views/#objectNames.objectNamePlural#/_form.cfm");
            local.inject=$generateFormField(objectname=objectNames.objectNameSingular, property=arguments.property, type=arguments.type);
        } else if(arguments.action EQ "output"){
            local.target=fileSystemUtil.resolvePath("app/views/#objectNames.objectNamePlural#/show.cfm");
            local.inject=$generateOutputField(objectname=objectNames.objectNameSingular, property=arguments.property, type=arguments.type);
        }
        local.content=fileRead(local.target);
        // inject into position CLI-Appends-Here
        local.content = replaceNoCase(local.content, '<!--- CLI-Appends-Here --->', local.inject & cr & '<!--- CLI-Appends-Here --->', 'all');
        // Replace tokens with ## tags
        local.content = Replace(local.content, "~[~", "##", "all");
        local.content = Replace(local.content, "~]~", "##", "all");
        // Finally write out the file
        file action='write' file='#local.target#' mode ='777' output='#trim(local.content)#';
    }

    // Inject CLI content into index template
    function $injectIntoIndex(required struct objectNames, required string property, required string type){
        local.target=fileSystemUtil.resolvePath("app/views/#objectNames.objectNamePlural#/index.cfm");
        local.thead="					<th>#helpers.capitalize(arguments.property)#</th>";
        local.tbody="					<td>" & cr & "						~[~#arguments.property#~]~" & cr & "					</td>";

        local.content=fileRead(local.target);
        // inject into position CLI-Appends-Here
        local.content = replaceNoCase(local.content, '                    <!--- CLI-Appends-thead-Here --->', local.thead & cr & '                    <!--- CLI-Appends-thead-Here --->', 'all');
        local.content = replaceNoCase(local.content, '                    <!--- CLI-Appends-tbody-Here --->', local.tbody & cr & '                    <!--- CLI-Appends-tbody-Here --->', 'all');
        // Replace tokens with ## tags
        local.content = Replace(local.content, "~[~", "##", "all");
        local.content = Replace(local.content, "~]~", "##", "all");
        // Finally write out the file
        file action='write' file='#local.target#' mode ='777' output='#trim(local.content)#';
    }

    // Returns contents for a default (non crud) action
    function $returnAction(required string name, string hint=""){
    	var rv="";
    	var name = trim(arguments.name);
    	var hint = trim(arguments.hint);

    	rv = fileRead( getTemplateDirectory() & '/ActionContent.txt' );

    	if(len(hint) == 0){
    		hint = name;
    	}

		rv = replaceNoCase( rv, '|ActionHint|', hint, 'all' );
		rv = replaceNoCase( rv, '|Action|', name, 'all' ) & cr & cr;
        return rv;
    }

	// Default output for show.cfm:
 	function $generateOutputField(required string objectName, required string property, required string type){
		var rv="<p><strong>#helpers.capitalize(property)#</strong><br />~[~";
		switch(type){
			// Return a checkbox
			case "boolean":
				rv&="yesNoFormat(#objectName#.#property#)";
			break;
			// Return a calendar
			case "date":
				rv&="dateFormat(#objectName#.#property#)";
			break;
			// Return a time picker
			case "time":
				rv&="timeFormat(#objectName#.#property#)";
			break;
			// Return a calendar and time picker
			case "datetime":
			case "timestamp":
				rv&="dateTimeFormat(#objectName#.#property#)";
			break;
			// Return a text field if everything fails, i.e assume string
			// Let's escape the output to be safe
			default:
				rv&="encodeForHTML(#objectName#.#property#)";
			break;
		}
		rv&="~]~</p>";
		return rv;
 	}

 	function $generateFormField(required string objectName, required string property, required string type){
		var rv="";
		switch(type){
			// Return a checkbox
			case "boolean":
				rv="checkbox(objectName='#objectName#', property='#property#')";
			break;
			// Return a textarea
			case "text":
				rv="textArea(objectName='#objectName#', property='#property#')";
			break;
			// Return a calendar
			case "date":
				rv="dateSelect(objectName='#objectName#', property='#property#')";
			break;
			// Return a time picker
			case "time":
				rv="timeSelect(objectName='#objectName#', property='#property#')";
			break;
			// Return a calendar and time picker
			case "datetime":
			case "timestamp":
				rv="dateTimeSelect(objectName='#objectName#', property='#property#')";
			break;
			// Return a text field if everything fails, i.e assume string
			default:
				rv="textField(objectName='#objectName#', property='#property#')";
			break;
		}
		// We need to make these rather unique incase the view file has *any* pre-existing
		rv = "~[~" & rv & "~]~";
		return rv;
 	}
//=====================================================================
//= 	DB Migrate
//=====================================================================
	// Before we can even think about using DBmigrate, we've got to check a few things
	function $preConnectionCheck(){
		var serverJSON=fileSystemUtil.resolvePath("server.json");
 			if(!fileExists(serverJSON)){
 				error("We really need a server.json with a port number and a servername. We can't seem to find it.");
 			}

			 // Wheels folder in expected place? (just a good check to see if the user has actually installed wheels...)
 		var wheelsFolder=fileSystemUtil.resolvePath("vendor/wheels");
 			if(!directoryExists(wheelsFolder)){
 				error("We can't find your wheels folder. Check you have installed CFWheels, and you're running this from the site root: If you've not started an app yet, try wheels new myApp");
 			}

			 // Plugins in place?
 		var pluginsFolder=fileSystemUtil.resolvePath("plugins");
 			if(!directoryExists(wheelsFolder)){
 				error("We can't find your plugins folder. Check you have installed CFWheels, and you're running this from the site root.");
 			}

			 // Wheels 1.x requires dbmigrate plugin
 		// Wheels 2.x has dbmigrate + dbmigratebridge equivalents in core
 		if($isWheelsVersion(1, "major")){

 			var DBMigratePluginLocation=fileSystemUtil.resolvePath("app/plugins/dbmigrate");
 			if(!directoryExists(DBMigratePluginLocation)){
 				error("We can't find your plugins/dbmigrate folder? Please check the plugin is successfully installed; if you've not started the server using server start for the first time, this folder may not be created yet.");
 			}

			var DBMigrateBridgePluginLocation=fileSystemUtil.resolvePath("app/plugins/dbmigratebridge");
 			if(!directoryExists(DBMigrateBridgePluginLocation)){
 				error("We can't find your plugins/dbmigratebridge folder? Please check the plugin is successfully installed;  if you've not started the server using server start for the first time, this folder may not be created yet.");
 			}
 		}

	}

	// Get information about the currently running server so we can send commmands
	function $getServerInfo(){
		var serverDetails = serverService.resolveServerDetails( serverProps={ webroot=getCWD() } );
  		local.host              = serverDetails.serverInfo.host;
  		local.port              = serverDetails.serverInfo.port;
  		local.serverURL		  = "http://" & local.host & ":" & local.port;
	  	return local;
	}

	// Construct remote URL depending on wheels version
	string function $getBridgeURL() {
		var serverInfo=$getServerInfo();
		var geturl=serverInfo.serverUrl;
  			getURL &= "/?controller=wheels&action=wheels&view=cli";
  		return geturl;
	}

	// Basically sends a command
	function $sendToCliCommand(string urlstring="&command=info"){
		targetURL=$getBridgeURL() & arguments.urlstring;

		$preConnectionCheck();

		loc = new Http( url=targetURL ).send().getPrefix();
		print.line("Sending: " & targetURL);
		
		if(isJson(loc.filecontent)){
  			loc.result=deserializeJSON(loc.filecontent);
  			if(structKeyexists(loc.result, "success") && loc.result.success){
					print.line("Call to bridge was successful.");
  				return loc.result;
  			}
  		} else {
  			print.line(helpers.stripTags(Formatter.unescapeHTML(loc.filecontent)));
  			print.line("Tried #targetURL#");
  			error("Error returned from DBMigrate Bridge");
  		}
	}

  	// Create the physical migration cfc in /db/migrate/
	function $createMigrationFile(required string name, required string action, required string content){
			var directory=fileSystemUtil.resolvePath("app/migrator/migrations");
			if(!directoryExists(directory)){
				directoryCreate(directory);
			}
	  		extendsPath="wheels.migrator.Migration";
	  		content=replaceNoCase(content, "|DBMigrateExtends|", extendsPath, "all");
			content=replaceNoCase(content, "|DBMigrateDescription|", "CLI #action#_#name#", "all");
			var fileName=dateformat(now(),'yyyymmdd') & timeformat(now(),'HHMMSS') & "_cli_#action#_" & name & ".cfc";
			var filePath=directory & "/" & fileName;
			file action='write' file='#filePath#' mode ='777' output='#trim( content )#';
			print.line( 'Created #fileName#' );
	}

	//=====================================================================
//=     Templates
//=====================================================================

    // Return .txt template location
    public string function getTemplate(required string template){
			//Copy template files to the application folder if they do not exist there
			ensureSnippetTemplatesExist();
			var templateDirectory=getTemplateDirectory();
			var rv=templateDirectory & "/" & template;
			return rv;
	}

	// NB, this path is the only place with the module folder name in it: would be good to find a way around that
	public string function getTemplateDirectory(){
			var current={
		webRoot		= getCWD(),
		moduleRoot	= expandPath("/wheels-cli/")
	};

			// attempt to get the templates directory from the current web root
			if ( directoryExists( current.webRoot & "app/snippets" ) ) {
					var templateDirectory=current.webRoot & "app/snippets";
			} else if ( directoryExists( current.moduleRoot & "templates" ) ) {
					var templateDirectory=current.webRoot & "app/snippets";
			} else {
					error( "#templateDirectory# Template Directory can't be found." );
			}
			return templateDirectory;
	}

	//Copies template files to the application folder if they do not exist there
	public void function ensureSnippetTemplatesExist() {
		var current = {
			webRoot     = getCWD(),
			moduleRoot  = expandPath("/wheels-cli/templates/"),
			targetDir   = getCWD() & "app/snippets/"
		};
	
		// Skip copying if the target already exists
		if (!directoryExists(current.targetDir)) {
			directoryCreate(current.targetDir);
	
			// List of files in the root of templates to exclude
			var excludedRootFiles = ["BoxJSON.txt", "ConfigAppContent.txt", "ConfigDataSourceH2Content.txt", "ConfigReloadPasswordContent.txt", "ConfigRoutes.txt", "WheelsBoxJSON.txt"];
			var excludedFolders = ["bootstrap"];
	
			// Get all entries (files + folders) in the templates directory
			var entries = directoryList(current.moduleRoot, false, "query");
	
			for (var entry in entries) {
				var entryPath = current.moduleRoot & entry.name;
				var targetPath = current.targetDir & entry.name;
	
				if (entry.type == "File") {
					// Skip excluded root-level files
					if (!arrayContainsNoCase(excludedRootFiles, entry.name)) {
						fileCopy(entryPath, targetPath);
					}
				} else if (entry.type == "Dir") {
					// Skip excluded folders (like bootstrap)
					if (!arrayContainsNoCase(excludedFolders, entry.name)) {
						directoryCopy(entryPath, targetPath, true);
					}
				}
			}
		}
	}
}
