# CFWheels CLI for CommandBox

This is a basic port of the Rails command line;
Skips things like `rails server` which are provided by commandBox already.

## Install

As this isn't on Forgebox yet, clone to `.CommandBox\cfml\modules\cfwheels-cli` and restart CommandBox;  
Ensure that the path has `cfwheels-cli` in it (not `cfwheelscli`) or anything else.

## Commands

### New Application

`wheels new`  
Starts a new installation wizard: creates a new CFWheels installation in a folder called `[AppName]` in the current directory. Defaults to the latest production version of CFWheels. TODO: add version (so `wheels new @2.x` or `@1.4.x` etc);

Sets up:
 - wheels
 - datasource name
 - reload password
 - application name
 - urlrewrite.xml
 - turns on url rewriting and sets `index.cfm` in settings
 - Copies over DBMigrate and DBMigratebridge plugins required for active record style integration with CLI.

### Scaffolding

Scaffolding creates a full CRUD model, controller & view files from a singluar noun, including DB Migration Schema  
TODO: add test scaffolding  
TODO: check CamelCasing..

`wheels scaffold [Name]`

Examples:  
`wheels scaffold Creditcard`

Will create: 
 - Model: 		`/models/Creditcard.cfc` with CRUD actions
 - Controller: 	`/controllers/Creditcards.cfc`
 - Test:       	`/test/controllers/Creditcards_controller_test.cfc` // TODO
 - Test:       	`/test/models/Creditcard_model_test.cfc` // TODO
 - DB:			`/db/migrate/YYYYMMDDHHMMSS_create_table_creditcards.cfc`
 - Views:      	`/views/creditcards/index.cfm` + Default CRUD files etc 

 or with optional arguments

`wheels scaffold Creditcard open,debit,credit,close`

Will create: 
 - Model: 		`/models/Creditcard.cfc` with specified actions
 - Controller: 	`/controllers/Creditcards.cfc`
 - Test:       	`/test/controllers/Creditcards_controller_test.cfc` // TODO
 - Test:       	`/test/models/Creditcard_model_test.cfc` // TODO
 - Views:      	`/views/creditcards/debit.cfm` [etc] 

The `scaffold` command uses the `generate` and `dbmigrate` command internally to do all of this:

### Generate

The `wheels generate` command uses templates to create a whole lot of things.

`wheels generate [Type] [Name] [Options]`  

`wheels generate` takes several sub commands:
 - `controller` - Generate a controller with optional specified actions
 - `model` - Generates a model file in `/models/`
 - `view` - Generates a simple view file in `/views/[name]/[viewName]`
 - `test` - Generates test files for model/controller/view in `/test/[name]`
 - `property` - Generates a property to add to a model
 
Examples:

**Controllers**

`wheels generate controller foo`  
Generates `Foo.cfc` in `/controllers/` with default CRUD actions (but not view files)

`wheels generate controller foo open,debit,credit,close`  
Generates `Foo.cfc` in `/controllers/` with 4 actions - `open,debit,credit,close` (but not view files)

**Models**

`wheels generate model foo`  
Generates `Foo.cfc` in `/models/`

**Views**

`wheels generate view foo index`  
Generates `index.cfm` in `/views/foo/`  
TODO: allow to accept list of actions, i.e, foo,bar,three etc

`wheels generate view foo edit crud/edit`  
Generates `edit.cfm` in `/views/foo/` using `templates/crud/edit.txt` 

**Tests**

`wheels generate test foo`  // TODO

**Properties**

`wheels generate property car registration`  
Adds a column to the "Car" DB model, and TODO: generate and insert appropriate form fields. Might turn this more into an interactive wizard as there's so many potential arguments.

### DBMigrate

The dbmigrate command powers the DBMigrateplugin via a bridging plugin.  
Used in `scaffold/generate` commands for all database interaction.

`wheels dbmigrate info`  
Get DB migrate information (list of possible migrations etc) directly from the DBMigrate plugin

`wheels dbmigrate latest`  
Migrate to the latest version of the DB schema

`wheels dbmigrate exec 098098098_foo`  
Migrate to version 098098098_foo

`wheels dbmigrate exec 0`  
Migrate to version 0: this is essentially same as resetting the database

`wheels dbmigrate up`  
TODO: Go up a version from the current

`wheels dbmigrate down`  
TODO: Go down a version from the current

`wheels dbmigrate create [something]`  
i.e, `wheels dbmigrate create table dogs` to create the dogs table.  
 TODO: columns, etc etc

`wheels dbmigrate remove [something]`  
i.e, `wheels dbmigrate remove table dogs`: Delete table Dogs

`wheels dbmigrate update [something]`  
i.e, `wheels dbmigrate update table dogs`: update table Dogs

`wheels dbmigrate rename [something]`   
i.e, `wheels dbmigrate rename table dogs`: Rename Dogs



### Test Suite

Run tests from the command line.  

`wheels test core 	[serverName] [reload] [debug]`  
`wheels test app 	[serverName] [reload] [debug]`  
`wheels test plugin  [pluginName] [serverName] [debug]`   

### Misc

`wheels info`  
Displays information about this module, such as Version number