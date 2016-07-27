component accessors="true" singleton { 
	property name='helpers'	inject='helpers@wheels';
 
    // Returns contents for a default (non crud) action
    public string function returnAction(required string name, string hint=""){
    	var loc={
    		templateDirectory = helpers.getTemplateDirectory(),
    		name = trim(arguments.name),
    		hint = trim(arguments.hint),
    		rv=""
    	}
    	var CR = chr( 13 );
    	loc.rv = fileRead( loc.templateDirectory & '/ActionContent.txt' ); 
    	
    	if(len(loc.hint) == 0){
    		loc.hint = loc.name;
    	}

		loc.rv = replaceNoCase( loc.rv, '|ActionHint|', loc.hint, 'all' );
		loc.rv = replaceNoCase( loc.rv, '|Action|', loc.name, 'all' ) & cr & cr; 
		
        return loc.rv;
    }
}