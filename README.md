## Salesforce ETL (Extract Transform Load) Mapping Script(s)

We have multiple Salesforce "orgs" (instances) and need to merge them into one.
This will *dramatically* streamline our business, innovation and training.

- - -

### Getting Started

[ ] Clone the project repository to your local machine

    $ git clone git://github.com/nelsonic/sfetlmap.git

[ ] create etl_mapping.yml from etl_mapping.yml.example

    $ cp config/etl_mapping.yml.example config/etl_mapping.yml

[] change username, password, token, client_id, client_secret in 
your config/etl_mapping.yml file.

[ ] rspec # run unit tests

- - -



The code committed to this **Public** *repo* is using 
[**OpenSource**](http://en.wikipedia.org/wiki/Open_source) modules:
- [Restforce](https://github.com/ejholmes/restforce)
- [MetaForce](https://github.com/ejholmes/metaforce)
- [Nokogiri](http://nokogiri.org/Nokogiri.html)
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

This work is *not* 
[**"Secret Sauce"**](http://en.wikipedia.org/wiki/Secret_ingredient) or 
[**"Competitive Info"**](http://en.wikipedia.org/wiki/Competitive_intelligence) 
if anything it shows people we are *streamlining* our ops. But that's 
[**"Public Knowledge"**](http://techcrunch.com/tag/groupon/). Everyone knows
that Andrew AcquiHired [*MyCityDeal*](http://goo.gl/SBAeS) but never fully 
integrated/migrated Groupon *"International"* into the main platform/org.
Again, this is *widely known* info! See:
[*"Maybe International Can Wait"*](http://goo.gl/DpOyy) or Econsultancy: 
http://econsultancy.com/us/blog/11246-did-international-expansion-kill-groupon

Right, enough *chit chat* lets get write some **code**!

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

This is from a Development Sandbox: 
[response.xml](https://github.com/nelsonic/sfetlmap/blob/master/examples/response.xml)
 ( *Obiviously* this has been edited to hide identity of user/email! )

The response xml from the Production Org was *useless*: 
[insufficient_access.xml](https://github.com/nelsonic/sfetlmap/blob/master/examples/insufficient_access.xml)

The last section in the 
[insufficient_access.xml](https://github.com/nelsonic/sfetlmap/blob/master/examples/insufficient_access.xml)
file tells us that we *need* a user with **"ModifyAllData
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


#### Other
- Kal Raman to *Streamline* Groupon:
http://www.chicagobusiness.com/article/20120922/ISSUE01/309229981/

- - -
