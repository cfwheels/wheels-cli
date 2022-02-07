/**
 *  Create a blank CFWheels app from one of our app templates or a template using a valid Endpoint ID which can come from .
 *  ForgeBox, HTTP/S, git, github, etc.
 *  By default it will create the application in your current directory.
 * .
 * {code:bash}
 * wheels create app myApp
 * {code}
 * .
 *  Here are the basic templates that are available for you that come from ForgeBox
 *  - Base (default)
 *  - HelloWorld
 *  - HelloDynamic
 * .
 * {code:bash}
 * wheels create app template=base
 * {code}
 * .
 * The template parameter can also be any valid Endpoint ID, which includes a Git repo or HTTP URL pointing to a package.
 * .
 * {code:bash}
 * wheels create app template=http://site.com/myCustomAppTemplate.zip
 * {code}
 *
 **/
component aliases="wheels g app" extends="../base" {

  /**
   * Constructor
   */
  function init( ) {
    // Map these shortcut names to the actual ForgeBox slugs
    variables.templateMap = {
      'Base'        : 'cfwheels-template-base',
      'HelloWorld'  : 'cfwheels-template-helloworld',
      'HelloDynamic': 'cfwheels-template-hellodynamic',
      'HelloPages'  : 'cfwheels-template-hellopages'
    };

    return this;
  }

  /**
   * @name                The name of the app you want to create
   * @template            The name of the app template to generate (or an endpoint ID like a forgebox slug)
   * @template.optionsUDF templateComplete
   * @directory           The directory to create the app in
   * @init                "init" the directory as a package if it isn't already
   **/
  function run(
    name         = 'My CFWheels App',
    template     = 'Base',
    directory    = getCWD(),
    boolean init = false,
  ) {
		// Check for wizard argument
		if ( arguments.wizard ) {
			runCommand( "wheels g app-wizard" );
			return;
		}

    // This will make the directory canonical and absolute
    arguments.directory = resolvePath( arguments.directory );

    // Validate directory, if it doesn't exist, create it.
    if ( !directoryExists( arguments.directory ) ) {
      directoryCreate( arguments.directory );
    }

    // If the template is one of our "shortcut" names
    if ( variables.templateMap.keyExists( arguments.template ) ) {
      // Replace it with the actual ForgeBox slug name.
      arguments.template = variables.templateMap[arguments.template];
    }

    // Install the template
    packageService.installPackage(
      ID                      = arguments.template,
      directory               = arguments.directory,
      save                    = false,
      saveDev                 = false,
      production              = false,
      currentWorkingDirectory = arguments.directory
    );

    // Check for the @appname@ in .project files
    if ( fileExists( '#arguments.directory#/.project' ) ) {
      var sProject = fileRead( '#arguments.directory#/.project' );
      sProject     = replaceNoCase(
        sProject,
        '@appName@',
        arguments.name,
        'all'
      );
      file action="write" file="#arguments.directory#/.project" mode="755" output="#sProject#";
    }

    // Init, if not a package as a Box Package
    if ( arguments.init && !packageService.isPackage( arguments.directory ) ) {
      var originalPath = getCWD();
      // init must be run from CWD
      shell.cd( arguments.directory );
      command( 'init' )
        .params(
          name   = arguments.name,
          slug   = replace( arguments.name, ' ', '', 'all' ),
          wizard = arguments.initWizard
        )
        .run();
      shell.cd( originalPath );
    }

    // Run postInstallAll script
    command( 'package run-script' ).params( scriptname = 'postInstallAll' ).run();

    // Prepare defaults on box.json so we remove template based ones
    command( 'package set' )
      .params(
        name     = arguments.name,
        slug     = variables.formatterUtil.slugify( arguments.name ),
        version  = '1.0.0',
        location = '',
        scripts  = '{}'
      )
      .run();
  }

  /**
   * Returns an array of cfwheels templates available
   */
  function templateComplete( ) {
    return variables.templateMap.keyList().listToArray();
  }

}
