component { 

    // Module Properties 
    this.autoMapModels  = true;
    this.modelNamespace = "wheels";
    this.cfmapping      = "wheels"; 

    function configure(){
        // Meta Data 
        settings={ 
            version="0.0.1-Alpha2", 
        }  
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