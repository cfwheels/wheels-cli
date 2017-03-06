component {
    /*
        This looks for any potential install <slugname> commands, checks if they're CFWheels plugins
        and attempts to deal with them in the appropriate way
    */
    property name='fileSystemUtil'     inject='FileSystem';
    property name='Formatter'     inject='Formatter';

    function onInstall( required struct interceptData ) {

       var isWheelsPlugin               = interceptData.artifactDescriptor.type == "cfwheels-plugins" ? true:false;
       var isValidWheelsInstallation    = directoryExists( fileSystemUtil.resolvePath("wheels")) ? true:false;
       var isValidPluginsDirectory      = directoryExists( fileSystemUtil.resolvePath("plugins")) ? true:false;

       if(isWheelsPlugin){

           systemOutput('CFWheels Plugin Detected', true);

           if(isValidWheelsInstallation && isValidPluginsDirectory){
                systemOutput('CFWheels Installation Found', true);
                // Just changing the directory isn't enough, as it would resolve to:
                // plugins/shortcodes/cfwheels-shortcodes-0.2/shortcodes.cfc
                // So we need to repackage a bit.

                // Get Version from the Forgebox data
                var pluginVersion= interceptData.ARTIFACTDESCRIPTOR.version;
                var pluginSlug=interceptData.ARTIFACTDESCRIPTOR.slug;

                // Get Name from the CFC to ensure it matches (the forgebox / git slug could be different)
                // i.e, neokoenig/cfwheels-plugin-example = helloWorld.cfc
                var pluginName = "";

                 systemOutput(interceptData, true);
                //interceptData.installDirectory=fileSystemUtil.resolvePath('plugins');
           } else {
                systemOutput('No CFWheels Installation or plugin directory Found, proceeding with normal installation', true);
           }

       } else {
            // Not a wheels plugin, go away.
       }
    }
}
