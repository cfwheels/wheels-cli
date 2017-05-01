component {
    /*
        After installation of a wheels plugin, ensure we've got the .zip named properly.

        interceptData
          installArgs - Struct containing the following keys used in installation of the package.
            ID - The ID of the package to install
            directory - Directory to install to. May be null, if none supplied.
            save - Flag to save box.json dependency
            saveDev - Flag to save box.json dev dependency
            production - Flag to perform a production install
            currentWorkingDirectory - Original working directory that requested installation
            verbose - Flag to print verbose output
            force - Flag to force installation
            packagePathRequestingInstallation - Path to package requesting installing. This climbs the folders structure for nested dependencies.

    */
    property name='fileSystemUtil'     inject='FileSystem';
    property name='Formatter'     inject='Formatter';
    property name='packageService' inject='packageService';

    function postInstall( required struct interceptData ) {
       var pluginFolder                 = fileSystemUtil.resolvePath("plugins");
       var isValidWheelsInstallation    = directoryExists( fileSystemUtil.resolvePath("wheels")) ? true:false;
       var isValidPluginsDirectory      = directoryExists( pluginFolder ) ? true:false;

       if(isValidWheelsInstallation && isValidPluginsDirectory){
          var pluginList=DirectoryList( pluginFolder, false, "query" );
          systemOutput(pluginList, true);
          for(plugin in pluginList){
            if(plugin.type == 'Dir'){
              var pluginDirectory   = pluginFolder & '/' & plugin.name;
              systemOutput(pluginDirectory , true);

              var pluginBoxJson     = packageService.readPackageDescriptorRaw( pluginDirectory );
              systemOutput(pluginBoxJson, true);

              var pluginVersion     = pluginBoxJson.version;
              var packageDirectory  = pluginBoxJson.packageDirectory;
              var sourceFolder      = pluginFolder & '/' & packageDirectory;
              var zipString         = pluginFolder & '/' & packageDirectory & '-' & pluginVersion & ".zip";
              zip
                    action="zip"
                    recurse="yes"
                    showDirectory="yes"
                    source="#sourceFolder#"
                    file="#zipString#";
            }
          }
       }
      // For each Wheels plugin in /plugins/, check for box.json and create a versioned zip if required

      /*
       var isWheelsPlugin               = interceptData.artifactDescriptor.type == "cfwheels-plugins" ? true:false;
       var isValidWheelsInstallation    = directoryExists( fileSystemUtil.resolvePath("wheels")) ? true:false;
       var isValidPluginsDirectory      = directoryExists( fileSystemUtil.resolvePath("plugins")) ? true:false;

       if(isWheelsPlugin){


           if(isValidWheelsInstallation && isValidPluginsDirectory){
                systemOutput('CFWheels Plugin Detected, creating zip', true);
                var pluginVersion     = interceptData.ARTIFACTDESCRIPTOR.version;
                var packageDirectory  = interceptData.ARTIFACTDESCRIPTOR.packageDirectory;

                var zipString         = packageDirectory & '-' & pluginVersion & ".zip";
                var zipDirectory      = fileSystemUtil.resolvePath("plugins/" & packageDirectory);
                  zip
                    action="zip"
                    recurse="yes"
                    showDirectory="yes"
                    source="#zipDirectory#"
                    destination="#fileSystemUtil.resolvePath("plugins/") & zipString#";
           }

       } else {
            // Not a wheels plugin, go away.
       }
       */
    }
}
