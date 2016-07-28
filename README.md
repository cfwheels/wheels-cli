# CFWheels CLI for CommandBox

This is a basic port (without Active record etc) of the Rails command line;
Skips things like `rails server` which are provided by commandBox already.

## Install

As this isn't on Forgebox yet, clone to `.CommandBox\cfml\modules\cfwheels-cli` and restart CommandBox;  
Ensure that the path has `cfwheels-cli` in it (not `cfwheelscli`) or anything else.

## Commands

### New Application

`wheels new [AppName]`  
Creates a new CFWheels installation in a folder called `[AppName]` in the current directory. Defaults to the latest production version of CFWheels. TODO: add version (so `wheels new app @2.x` or `@1.4.x` etc);

Sets up:
 - wheels
 - datasource name
 - reload password
 - application name
 - urlrewrite.xml
 - turns on url rewriting and sets `index.cfm` in settings

### Scaffolding

Scaffolding creates a full CRUD model, controller & view files from a singluar noun  
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
 - Views:      	`/views/creditcards/index.cfm` + Default CRUD files etc 

 or with optional arguments

`wheels scaffold Creditcard open,debit,credit,close`

Will create: 
 - Model: 		`/models/Creditcard.cfc` with specified actions
 - Controller: 	`/controllers/Creditcards.cfc`
 - Test:       	`/test/controllers/Creditcards_controller_test.cfc` // TODO
 - Test:       	`/test/models/Creditcard_model_test.cfc` // TODO
 - Views:      	`/views/creditcards/debit.cfm` [etc] 

The `scaffold` command uses the `generate` command internally to do all of this:

### Generate

The `wheels generate` command uses templates to create a whole lot of things.

`wheels generate [Type] [Name] [Options]`  

`wheels generate` takes several sub commands:
 - `controller` - Generate a controller with optional specified actions
 - `model` - Generates a model file in `/models/`
 - `view` - Generates a simple view file in `/views/[name]/[viewName]`
 - `test` - Generates test files for model/controller/view in `/test/[name]`
 
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

### Test Suite

Run tests from the command line.  

`wheels test core 	[serverName] [reload] [debug]`
`wheels test app 	[serverName] [reload] [debug]`
`wheels test plugin  [pluginName] [serverName] [debug]` 

### Misc

`wheels info`  
Displays information about this module, such as Version number