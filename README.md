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

If I then login to one of the Sandboxes where I do have "ModifyAllData"

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><describeMetadataResponse><result><metadataObjects><childXmlNames>CustomLabel</childXmlNames><directoryName>labels</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>labels</suffix><xmlName>CustomLabels</xmlName></metadataObjects><metadataObjects><directoryName>staticresources</directoryName><inFolder>false</inFolder><metaFile>true</metaFile><suffix>resource</suffix><xmlName>StaticResource</xmlName></metadataObjects><metadataObjects><directoryName>scontrols</directoryName><inFolder>false</inFolder><metaFile>true</metaFile><suffix>scf</suffix><xmlName>Scontrol</xmlName></metadataObjects><metadataObjects><directoryName>components</directoryName><inFolder>false</inFolder><metaFile>true</metaFile><suffix>component</suffix><xmlName>ApexComponent</xmlName></metadataObjects><metadataObjects><directoryName>pages</directoryName><inFolder>false</inFolder><metaFile>true</metaFile><suffix>page</suffix><xmlName>ApexPage</xmlName></metadataObjects><metadataObjects><directoryName>queues</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>queue</suffix><xmlName>Queue</xmlName></metadataObjects><metadataObjects><childXmlNames>CustomField</childXmlNames><childXmlNames>BusinessProcess</childXmlNames><childXmlNames>RecordType</childXmlNames><childXmlNames>WebLink</childXmlNames><childXmlNames>ValidationRule</childXmlNames><childXmlNames>NamedFilter</childXmlNames><childXmlNames>SharingReason</childXmlNames><childXmlNames>ListView</childXmlNames><childXmlNames>FieldSet</childXmlNames><childXmlNames>ApexTriggerCoupling</childXmlNames><directoryName>objects</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>object</suffix><xmlName>CustomObject</xmlName></metadataObjects><metadataObjects><directoryName>reportTypes</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>reportType</suffix><xmlName>ReportType</xmlName></metadataObjects><metadataObjects><directoryName>reports</directoryName><inFolder>true</inFolder><metaFile>false</metaFile><suffix>report</suffix><xmlName>Report</xmlName></metadataObjects><metadataObjects><directoryName>dashboards</directoryName><inFolder>true</inFolder><metaFile>false</metaFile><suffix>dashboard</suffix><xmlName>Dashboard</xmlName></metadataObjects><metadataObjects><directoryName>analyticSnapshots</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>snapshot</suffix><xmlName>AnalyticSnapshot</xmlName></metadataObjects><metadataObjects><directoryName>layouts</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>layout</suffix><xmlName>Layout</xmlName></metadataObjects><metadataObjects><directoryName>documents</directoryName><inFolder>true</inFolder><metaFile>true</metaFile><xmlName>Document</xmlName></metadataObjects><metadataObjects><directoryName>weblinks</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>weblink</suffix><xmlName>CustomPageWebLink</xmlName></metadataObjects><metadataObjects><directoryName>tabs</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>tab</suffix><xmlName>CustomTab</xmlName></metadataObjects><metadataObjects><directoryName>customApplicationComponents</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>customApplicationComponent</suffix><xmlName>CustomApplicationComponent</xmlName></metadataObjects><metadataObjects><directoryName>applications</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>app</suffix><xmlName>CustomApplication</xmlName></metadataObjects><metadataObjects><directoryName>letterhead</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>letter</suffix><xmlName>Letterhead</xmlName></metadataObjects><metadataObjects><directoryName>email</directoryName><inFolder>true</inFolder><metaFile>true</metaFile><suffix>email</suffix><xmlName>EmailTemplate</xmlName></metadataObjects><metadataObjects><childXmlNames>WorkflowFieldUpdate</childXmlNames><childXmlNames>WorkflowKnowledgePublish</childXmlNames><childXmlNames>WorkflowTask</childXmlNames><childXmlNames>WorkflowAlert</childXmlNames><childXmlNames>WorkflowSend</childXmlNames><childXmlNames>WorkflowOutboundMessage</childXmlNames><childXmlNames>WorkflowRule</childXmlNames><childXmlNames xsi:nil="true"/><directoryName>workflows</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>workflow</suffix><xmlName>Workflow</xmlName></metadataObjects><metadataObjects><directoryName>roles</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>role</suffix><xmlName>Role</xmlName></metadataObjects><metadataObjects><directoryName>territories</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>territory</suffix><xmlName>Territory</xmlName></metadataObjects><metadataObjects><directoryName>groups</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>group</suffix><xmlName>Group</xmlName></metadataObjects><metadataObjects><directoryName>homePageComponents</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>homePageComponent</suffix><xmlName>HomePageComponent</xmlName></metadataObjects><metadataObjects><directoryName>homePageLayouts</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>homePageLayout</suffix><xmlName>HomePageLayout</xmlName></metadataObjects><metadataObjects><directoryName>objectTranslations</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>objectTranslation</suffix><xmlName>CustomObjectTranslation</xmlName></metadataObjects><metadataObjects><directoryName>translations</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>translation</suffix><xmlName>Translations</xmlName></metadataObjects><metadataObjects><directoryName>flows</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>flow</suffix><xmlName>Flow</xmlName></metadataObjects><metadataObjects><directoryName>classes</directoryName><inFolder>false</inFolder><metaFile>true</metaFile><suffix>cls</suffix><xmlName>ApexClass</xmlName></metadataObjects><metadataObjects><directoryName>triggers</directoryName><inFolder>false</inFolder><metaFile>true</metaFile><suffix>trigger</suffix><xmlName>ApexTrigger</xmlName></metadataObjects><metadataObjects><directoryName>profiles</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>profile</suffix><xmlName>Profile</xmlName></metadataObjects><metadataObjects><directoryName>permissionsets</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>permissionset</suffix><xmlName>PermissionSet</xmlName></metadataObjects><metadataObjects><directoryName>datacategorygroups</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>datacategorygroup</suffix><xmlName>DataCategoryGroup</xmlName></metadataObjects><metadataObjects><directoryName>remoteSiteSettings</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>remoteSite</suffix><xmlName>RemoteSiteSetting</xmlName></metadataObjects><metadataObjects><directoryName>sites</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>site</suffix><xmlName>CustomSite</xmlName></metadataObjects><metadataObjects><childXmlNames>LeadOwnerSharingRule</childXmlNames><childXmlNames>LeadCriteriaBasedSharingRule</childXmlNames><directoryName>leadSharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>LeadSharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>CampaignOwnerSharingRule</childXmlNames><childXmlNames>CampaignCriteriaBasedSharingRule</childXmlNames><directoryName>campaignSharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>CampaignSharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>CaseOwnerSharingRule</childXmlNames><childXmlNames>CaseCriteriaBasedSharingRule</childXmlNames><directoryName>caseSharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>CaseSharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>ContactOwnerSharingRule</childXmlNames><childXmlNames>ContactCriteriaBasedSharingRule</childXmlNames><directoryName>contactSharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>ContactSharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>OpportunityOwnerSharingRule</childXmlNames><childXmlNames>OpportunityCriteriaBasedSharingRule</childXmlNames><directoryName>opportunitySharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>OpportunitySharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>AccountOwnerSharingRule</childXmlNames><childXmlNames>AccountCriteriaBasedSharingRule</childXmlNames><directoryName>accountSharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>AccountSharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>AccountTerritorySharingRule</childXmlNames><directoryName>accountTerritorySharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>AccountTerritorySharingRules</xmlName></metadataObjects><metadataObjects><childXmlNames>CustomObjectOwnerSharingRule</childXmlNames><childXmlNames>CustomObjectCriteriaBasedSharingRule</childXmlNames><directoryName>customObjectSharingRules</directoryName><inFolder>false</inFolder><metaFile>false</metaFile><suffix>sharingRules</suffix><xmlName>CustomObjectSharingRules</xmlName></metadataObjects><organizationNamespace></organizationNamespace><partialSaveAllowed>true</partialSaveAllowed><testRequired>false</testRequired></result></describeMetadataResponse></soapenv:Body></soapenv:Envelope>
```

