component {

    // Module Properties
    this.autoMapModels  = true;
    this.modelNamespace = "wheels";
    this.cfmapping      = "wheels";

    function configure(){
    }
    // Runs when module is loaded
    function onLoad(){
        log.info('CFWheels Module loaded successfully.' );
    }

    // Runs when module is unloaded
    function onUnLoad(){
        log.info('CFWheels Module unloaded successfully.' );
    }

}