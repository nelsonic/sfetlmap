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
    config/

This tells git to ignore any CSV Files and anything in /config 
(and its subfolders) you will notice thta the etl_mapping.yml does not show 
on GitHub. only the "example" which provides a template.

>>


- - -
### General Notes

- Kal Raman to *Streamline* Groupon:
http://www.chicagobusiness.com/article/20120922/ISSUE01/309229981/

- - -

### Example XML Response From Fore.com

( *Obiviously* this has been edited to hide identity of user/email! )

```xml
HTTPI executes HTTP POST using the net_http adapter
SOAP response (status 200):
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<soapenv:Body>
<loginResponse>
<result>
  <metadataServerUrl>https://eu0-api.salesforce.com/services/Soap/m/26.0/00D20000000MeJA</metadataServerUrl>
  <passwordExpired>false</passwordExpired>
  <sandbox>false</sandbox>
  <serverUrl>https://eu0-api.salesforce.com/services/Soap/u/26.0/00D20000000MeJA</serverUrl>
  <sessionId>00D20000000MeJA!AQEAQPDd8DgDpcY85HONUTgyGFCLKLvHiudeVtfJkJLTd7yMAOK3KGWf8TVmjcNfYUQCH_vf9MxB.aVblQZqNsi_7ErmCF3v</sessionId>
  <userId>00520000002XPWC43x</userId>
  <userInfo>
    <accessibilityMode>false</accessibilityMode>
    <currencySymbol xsi:nil="true"/>
    <orgAttachmentFileSizeLimit>26214400</orgAttachmentFileSizeLimit>
    <orgDefaultCurrencyIsoCode xsi:nil="true"/>
    <orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments>
    <orgHasPersonAccounts>false</orgHasPersonAccounts>
    <organizationId>00D20000000MeJAEA0</organizationId>
    <organizationMultiCurrency>true</organizationMultiCurrency>
    <organizationName>Groupon GmbH</organizationName>
    <profileId>00e20000001cryrAAA</profileId>
    <roleId>00E20000000oWjNEAU</roleId>
    <sessionSecondsValid>7200</sessionSecondsValid>
    <userDefaultCurrencyIsoCode>GBP</userDefaultCurrencyIsoCode>
    <userEmail>example@org.com</userEmail>
    <userFullName>Rules Engine API User</userFullName>
    <userId>00520000002XPWC43x</userId>
    <userLanguage>en_US</userLanguage>
    <userLocale>en_GB</userLocale>
    <userName>example@org.com</userName>
    <userTimeZone>Europe/Dublin</userTimeZone>
    <userType>Standard</userType>
    <userUiSkin>Theme3</userUiSkin>
  </userInfo>
</result>
</loginResponse>
</soapenv:Body>
</soapenv:Envelope>
SOAP request: https://eu0-api.salesforce.com/services/Soap/m/26.0/00D20000000MeJA
SOAPAction: "describeMetadata", Content-Type: text/xml;charset=UTF-8, Content-Length: 604
<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:tns="http://soap.sforce.com/2006/04/metadata" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" 
xmlns:ins0="http://soap.sforce.com/2006/04/metadata">
<env:Header>
<ins0:SessionHeader>
<ins0:sessionId>00D20000000MeJA!AQEAQPDd8DgDpcY85HONUTgyGFCLKLvHiudeVtfJkJLTd7yMAOK3KGWf8TVmjcNfYUQCH_vf9MxB.aVblQZqNsi_7ErmCF3v</ins0:sessionId>
</ins0:SessionHeader></env:Header><env:Body><ins0:describeMetadata></ins0:describeMetadata></env:Body></env:Envelope>
HTTPI executes HTTP POST using the net_http adapter
SOAP response (status 500):
<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:sf="http://soap.sforce.com/2006/04/metadata">
<soapenv:Body><soapenv:Fault><faultcode>sf:INSUFFICIENT_ACCESS</faultcode>
<faultstring>INSUFFICIENT_ACCESS: use of the Metadata API requires a user with the ModifyAllData permission</faultstring>
</soapenv:Fault></soapenv:Body>
</soapenv:Envelope>
```

This last bit tells us that we *need* a user with **"ModifyAllData
permission"** in order to *Read* the metadata...! :-(
