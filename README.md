## Salesforce ETL (Extract Transform Load) Mapping Script(s)

We have multiple Salesforce "orgs" (instances) and need to merge them into one.
This will *dramatically* streamline our business, innovation and training.

The code committed to this **Public** *repo* is using 
[**OpenSource**](http://en.wikipedia.org/wiki/Open_source) modules:
- [MetaForce](https://github.com/ejholmes/metaforce)
- [Nokogiri](http://nokogiri.org/Nokogiri.html)
- [Google_Drive](https://github.com/gimite/google-drive-ruby)
- etc

So it seems *logical* / *fair* to share our work so others can *benefit* 
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

- - -

### Getting Started


- - -

### Dev Log

First we're going to create our [.gitignore](http://git-scm.com/docs/gitignore) 
file so we can hide config and "tmp" (temporary) folders thus protecting any 
sensitive info. After that we can safely do **git add. && git commit -m 'msg'** 
to add files/changes. In Terminal window:

    $ vi .gitignore

Add the lines:

    *.csv
    /config

This tells git to ignore any CSV Files and anything in /config (and its subfolders)

>>


- - -
### General Notes

- Kal Raman to *Streamline* Groupon:
http://www.chicagobusiness.com/article/20120922/ISSUE01/309229981/

