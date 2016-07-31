/**
 * Info
 **/
component {
	
	property name='helpers'	inject='helpers@wheels';
	/**
	 * 
	 **/
	function run(  ) {
	var content	    = fileRead( helpers.getTemplate('/ConfigSettingsContent.txt' ) ); 
	content=replaceNoCase(content, '// set(dataSourceName="");', 'IAMCHANGED1', 'all'); 
	print.greenBoldLine( content);	 

	var content2	    = fileRead( helpers.getTemplate('crud/_form.txt' ) ); 
	content2=replaceNoCase(content2, '<!--- CLI-Appends-Here --->', 'I have been inserted.' & cr & '<!--- CLI-Appends-Here --->', 'all'); 
	print.greenBoldLine( content2);	 

	}

}