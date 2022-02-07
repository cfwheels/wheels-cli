/**
 * Creates a new CFWheels application. This is the recommended route
 * to start a new application.
 *
 * This command will ask for:
 *
 *  - An Application Name (a new directoery will be created with this name)
 *  - What wheels version you want to install
 *  - A reload Password
 *  - A datasource name
 *  - What local cfengine you want to run
 *  - If using Lucee, do you want to setup a local h2 dev database
 *  - Do you want to setup some basic Bootstrap templating
 *
 * {code:bash}
 * wheels new
 * {code}
 **/
component aliases="wheels g app-wizard, wheels new" extends="../base" {


  function run( ) {
    var appContent      = fileRead( helpers.getTemplate( '/ConfigAppContent.txt' ) );
    var settingsContent = fileRead( helpers.getTemplate( '/ConfigSettingsContent.txt' ) );
    var routesContent   = fileRead( helpers.getTemplate( '/ConfigRoutes.txt' ) );

    // ---------------- Welcome
    print.greenBoldLine( '========= Hello! Welcome to the Wizard ===========' )
      .greenBoldLine( '| Welcome to the CFWheels app wizard. We''re here |' )
      .greenBoldLine( '| to try and give you a helping hand to start yo |' )
      .greenBoldLine( '| CFWheels app.                                  |' )
      .greenBoldLine( '==================================================' )
      .line()
      .toConsole();

    // ---------------- Set an app Name
    // TODO: Add conditions on what can in an application name
    print.greenBoldLine( '========= We Need Some Information ===============' )
      .greenBoldLine( '| To get going, we''re going to need to know a    |' )
      .greenBoldLine( '| NAME for your application. We''ll start with    |' )
      .greenBoldLine( '| a name like MyCFWheelsApp. Keep in  mind       |' )
      .greenBoldLine( '| that a new directory will be created for your  |' )
      .greenBoldLine( '| app in your current working directory.         |' )
      .greenBoldLine( '==================================================' )
      .line()
      .toConsole();

    var appName = ask( message = 'Please enter a name for your application: ', defaultResponse = 'MyCFWheelsApp' );
    appName     = helpers.stripSpecialChars( appName );
    print.line().toConsole();

    // ---------------- Template
    print.greenBoldLine( '============= Application Template ===============' )
      .greenBoldLine( '| Please select a templates to use as the        |' )
      .greenBoldLine( '| starting point for your application. You can   |' )
      .greenBoldLine( '| select on of our official templates or enter   |' )
      .greenBoldLine( '| a custom endpoint ID which can come from       |' )
      .greenBoldLine( '| ForgeBox, HTTP/S, git, GitHub, etc.            |' )
      .greenBoldLine( '==================================================' )
      .toConsole();

    var template = multiselect( 'Which CFWheels Template shall we use? ' )
      .options( [
        {value: 'cfwheels-template-base', display: 'Base', selected: true},
        {value: 'cfwheels-template-helloworld', display: 'HelloWorld'},
        {value: 'cfwheels-template-hellodynamic', display: 'HelloDynamic'},
        {value: 'cfwheels-template-hellopages', display: 'HelloPages'},
        {value: 'custom', display: 'Enter a custom template endpoint'}
      ] )
      .required()
      .ask();

    if ( template == 'custom' ) {
      template = ask( message = 'Please enter a custom endpoint to use for the template: ' );
    }
    print.line().toConsole();

    // ---------------- Set reload Password
    print.greenBoldLine( '=========== And a ''Reload'' Password ==============' )
      .greenBoldLine( '| We also need a ''reload'' password to secure     |' )
      .greenBoldLine( '| your app. This can be something simple but     |' )
      .greenBoldLine( '| unique and known only to you. Your reload      |' )
      .greenBoldLine( '| password allows you to restart your app via    |' )
      .greenBoldLine( '| the URL. You can change it later if you need!  |' )
      .greenBoldLine( '==================================================' )
      .line()
      .toConsole();

    var reloadPassword = ask(
      message         = 'Please enter a ''reload'' password for your application: ',
      defaultResponse = 'changeMe'
    );
    print.line().toConsole();

    // ---------------- Set datasource Name
    print.greenBoldLine( '============= Data...Data...Data... ==============' )
      .greenBoldLine( '| All good apps need data. Unfortunately you''re  |' )
      .greenBoldLine( '| going to have to be responsible for this bit.  |' )
      .greenBoldLine( '| We''re expecting a valid DataSource to be       |' )
      .greenBoldLine( '| setup; so you''ll need mySQL or some other      |' )
      .greenBoldLine( '| supported DB server running locally. Once      |' )
      .greenBoldLine( '| you''ve setup a database, you''ll need to add it |' )
      .greenBoldLine( '| to the local CommandBox Lucee server which     |' )
      .greenBoldLine( '| we''ll start in a bit. For now, we just need to |' )
      .greenBoldLine( '| know what that datasource name will be.        |' )
      .greenBoldLine( '|                                                |' )
      .greenBoldLine( '| If you''re going to run lucee, we can           |' )
      .greenBoldLine( '| autocreate a development database for you.     |' )
      .greenBoldLine( '==================================================' )
      .line()
      .toConsole();

    var datasourceName = ask(
      message         = 'Please enter a datasource name if different from #appName#: ',
      defaultResponse = '#appName#'
    );

    if ( !len( datasourceName ) ) {
      datasourceName = appName;
    }
    print.line();

    // ---------------- Set default server.json engine
    print.greenBoldLine( '================== CFML Engine ===================' )
      .greenBoldLine( '| Now you need to specify the CFML engine you    |' )
      .greenBoldLine( '| wish to use. Once again you can choose one     |' )
      .greenBoldLine( '| from the list of available engines we have     |' )
      .greenBoldLine( '| supplied or specify a custom endpoint if you   |' )
      .greenBoldLine( '| need to test with a specific engine patch      |' )
      .greenBoldLine( '| point or snapshot. The custom endpoint can     |' )
      .greenBoldLine( '| come from ForgeBox, HTTP/S, git, GitHub, etc.  |' )
      .greenBoldLine( '==================================================' )
      .toConsole();

    var cfmlEngine = multiselect( 'Please select your preferred CFML engine? ' )
      .options( [
        {value: 'lucee', display: 'Lucee (Latest)', selected: true},
        {value: 'adobe', display: 'Adobe ColdFusion (Latest)'},
        {value: 'lucee@5', display: 'Lucee 5.x'},
        {value: 'lucee@4', display: 'Lucee 4.x'},
        {value: 'adobe@2021', display: 'Adobe ColdFusion 2021'},
        {value: 'adobe@2018', display: 'Adobe ColdFusion 2018'},
        {value: 'adobe@2016', display: 'Adobe ColdFusion 2016'},
        {value: 'adobe@11', display: 'Adobe ColdFusion 11'},
        {value: 'adobe@10', display: 'Adobe ColdFusion 10'},
        {value: 'custom', display: 'Enter a custom engine endpoint'}
      ] )
      .required()
      .ask();

    if ( cfmlEngine == 'custom' ) {
      cfmlEngine = ask( message = 'Please enter a custom endpoint to use for the CFML engine: ' );
    }

    var allowH2Creation = false;
    if ( listFirst( cfmlEngine, '@' ) == 'lucee' ) {
      allowH2Creation = true
    }

    // ---------------- Test H2 Database?
    if ( allowH2Creation ) {
      var createH2Embedded = confirm( 'As you are using Lucee, would you like to setup and use the H2 Java embedded SQL database for development? [y,n]' );
    } else {
      createH2Embedded = false;
    }
    
    // ---------------- Initialize as a package
    var initPackage = confirm( 'Finally, shall we initialize your application as a package by creating a box.json file? [y,n]' );
    
    print.line();
    print.line();
    print.greenBoldLine( '==================================================' )
      .greenBoldLine( '| Great! Think we''re all good to go. We''re going |' )
      .greenBoldLine( '| to create a CFWheels application for you with  |' )
      .greenBoldLine( '| the following parameters.                      |' )
      .greenBoldLine( '==================================================' )
      .greenBoldLine( '| Template              | #template# ' ) 
      .greenBoldLine( '| Application Name      | #appName# ' )
      .greenBoldLine( '| Install Directory     | #getCWD()##appName# ' ) 
      .greenBoldLine( '| Reload Password       | #reloadPassword# ' )
      .greenBoldLine( '| Datasource Name       | #datasourceName# ' )
      .greenBoldLine( '| CF Engine             | #cfmlEngine#' )
      .greenBoldLine( '| Setup H2 Database     | #createH2Embedded#' )
      .greenBoldLine( '| Initialize as Package | #initPackage#' )
      .greenBoldLine( '=========================' )
      .toConsole();

    print.line();

    
    if ( confirm( 'Sound good? [y/n]' ) ) {
      // call wheels g app 

      command( 'wheels g app' ).params( 
        name            = '#appName#',
        template        = '#template#',
        directory       = '#getCWD()##appName#', 
        reloadPassword  = '#reloadPassword#',
        datasourceName  = '#datasourceName#',
        cfmlEngine      = '#cfmlEngine#',
        setupH2         = #createH2Embedded#,
        init            = #initPackage#).run();

    } else {
      print.greenBoldLine( 'OK, another time then. *sobs* ' ).toConsole();
    }
    
  }

}
