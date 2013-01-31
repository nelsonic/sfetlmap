## Salesforce ETL (Extract Transform Load) Mapping Script(s)

We have *multiple* Salesforce "orgs" (instances) and need to merge them into **one**.
This will *dramatically* streamline our business, innovation and training.

The code is pretty self-explanatory. 
I've used verbose method names and there are only **2 files** doing all the work:

- **spec/sfmap_spec.rb** - runs tests to see if we can connect to salesforce and google docs,
if we can establish connections it then exercises the methods in sfmap.rb
- **lib/sfmap.rb** - contains all the methods for connecting to Salesforce 
(using the **Restforce** gem) and Google Drive (aka *"Docs"* via google_drive gem).

I borrowed a couple of methods from Tim's 
[ETL-Mapping](https://github.groupondev.com/tkuntz/etl-mapping)
Project, but ultimately simplified it to bare-bones and removed **dependencies** 
on *Java Ant Migration Tool*. 
The code is not a *"Jet Engine"* (i.e. *plenty* could be streamlined/shortened to Ruby one-liners, 
but it *works* and is easy for even a novice to to understand.

Feel free to re-factor / clean up if you have the time. 

For now it works so need to move on to other tasks! :-)
- - -

### Getting Started

- Clone the project repository to your local machine

    ~~$ git clone git://github.com/nelsonic/sfetlmap.git~~
    $ git clone git://github.groupondev.com/nelsoncorreia/sfetlmap.git

- Create etl_mapping.yml (*configuration file*) from etl_mapping.yml.example

    $ cp config/etl_mapping.yml.example config/etl_mapping.yml

- change username, password, token, client_id, client_secret in 
your **config/etl_mapping.yml** file.

- (Optional) Create a clone of the Mapping Spreadsheet and add the Key to the 'copy' 
key in config file so you can do a "trial run" of the script...

- Now you can run the Rspec unit tests file. (this will update the Spreadsheet if all tests pass)

    $ rspec spec/sfmap_spec.rb

- - -


The code committed to this **Public** *repo* is using 
[**OpenSource**](http://en.wikipedia.org/wiki/Open_source) modules:
- [Restforce](https://github.com/ejholmes/restforce)
- ~~[MetaForce](https://github.com/ejholmes/metaforce)~~
- ~~[Nokogiri](http://nokogiri.org/Nokogiri.html)~~
- [Google_Drive](https://github.com/gimite/google-drive-ruby)
- [Rspec](https://github.com/rspec/rspec)
- etc

So it seems *logical* & *fair* to share our work so others can *benefit* 
from it. 

**Sox/Security** note: the [.gitignore](http://git-scm.com/docs/gitignore) file
*specifically hides* all "sensitive" material such as passwords, database
structure (metadata) XML files and org names! There is Zero 
[PII](http://en.wikipedia.org/wiki/Personally_identifiable_information) so no
risk is posed. No *data* will *ever* be publicly visible.

### Dev Log

#### GitIgnore

First we're going to create our [.gitignore](http://git-scm.com/docs/gitignore) 
file so we can hide config and "tmp" (temporary) folders thus protecting any 
sensitive info. After that we can safely do **git add. && git commit -m 'msg'** 
to add files/changes. In Terminal window:

    $ vi .gitignore

Add the lines:

    *.csv
    config/

This tells git to ignore any CSV Files and anything in /config 
(and its subfolders) you will notice thta the etl_mapping.yml does not show 
on GitHub. only the "example" which provides a template.

#### Example XML Response From Fore.com (using Meatforce gem)

This is from a Development Sandbox: **examples/response.xml** 
( *Obiviously* this has been edited to hide identity of user/email! )

The response xml from the Production Org was *useless*: **examples/insufficient_access.xml**

The last section in the 
**examples/insufficient_access.xml** file tells us that we *need* a user with **"ModifyAllData
permission"** in order to *Read* the metadata...! :-(

Back to the drawing board... -> [Restforce](https://github.com/ejholmes/restforce)

#### Using Restforce to access Metadata via Remote Access

To use the [Restforce](https://github.com/ejholmes/restforce) gem you will need
to have a pair of **Remote Access** tokens for your Salesforce instance.
see: http://www.salesforce.com/us/developer/docs/api_rest/Content/quickstart_oauth.htm

I created a demo for this in examples/restforce.rb

This script needs to be 100% non-destructive. No data should be written back to
the "Origin" org (which in our case is a *Live* / *Production* instance!) and 
equally we do not want to overwrite anything in the Google Spreadsheet.


#### Google Drive 

Looping through a list of Worksheets in a google Docs (Drive) Spreadsheet will
return the following object to represent the sheet:

```
#<GoogleDrive::Worksheet worksheet_feed_url=
"https://spreadsheets.google.com/feeds/worksheets/your-sheet-key-private/full/od6", 
title="Origin Objects">
```

- - -
## Notes

#### Salesforce Metadata API

- http://www.salesforce.com/us/developer/docs/api_meta/index.htm

#### Learning Ruby Notes

- http://stackoverflow.com/questions/735073/best-way-to-require-all-files-from-a-directory-in-ruby
- Ruby Tricks: http://www.rubyinside.com/21-ruby-tricks-902.html
- Ruby Regular Expressions: http://net.tutsplus.com/tutorials/ruby/ruby-for-newbies-regular-expressions/

- - -
