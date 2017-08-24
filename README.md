# Welcome to the Dictionary Project #
The Dictionary project is the integration of TDS Student with the Merriam-Webster dictionary.

## License ##
This project is licensed under the [AIR Open Source License v1.0](http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf).

## Getting Involved ##
We would be happy to receive feedback on its capabilities, problems, or future enhancements:

* For general questions or discussions, please use the [Forum](http://forum.opentestsystem.org/viewforum.php?f=9).
* Feel free to **Fork** this project and develop your changes!

## Module Overview

### Web

Web module contains all the UI and implementation logic required for calling the Merriam-Webster REST API and transforming the response.

## Setup
In general, build the code and deploy the WAR file.

If the TDS_Student application is deployed using SSL/HTTPS, the webserver hosting the dictionary web application will also need to be secured. 
For security reasons, modern browsers now disable mixed active content by default, meaning that a secured web application cannot include 
non-secured content or make certain non-secured requests.

### Tomcat Configuration (Environment Variables)
The following parameters need to be set inside of the Tomcat server's context.xml on the Dictionary server:
```
<Parameter name="tds.dictionary.key.TDS_Dict_Collegiate" override="false" value="---Key for Merriam-Webster Dictionary ---"/>
<Parameter name="tds.dictionary.url.TDS_Dict_Collegiate" override="false" value="http://www.dictionaryapi.com/api/v1/references/collegiate/xml/"/>
<Parameter name="tds.dictionary.key.TDS_Dict_Learners" override="false" value="---Key for Dictionary ---"/>
<Parameter name="tds.dictionary.url.TDS_Dict_Learners" override="false" value="http://www.dictionaryapi.com/api/v1/references/learners/xml/"/>
<Parameter name="tds.dictionary.key.TDS_Dict_SD2" override="false" value="---Key for Dictionary ---"/>
<Parameter name="tds.dictionary.url.TDS_Dict_SD2" override="false" value="http://www.dictionaryapi.com/api/v1/references/sd2/xml/"/>
<Parameter name="tds.dictionary.key.TDS_Dict_SD3" override="false" value="---Key for Dictionary ---"/>
<Parameter name="tds.dictionary.url.TDS_Dict_SD3" override="false" value="http://www.dictionaryapi.com/api/v1/references/sd3/xml/"/>
<Parameter name="tds.dictionary.key.TDS_Dict_SD4" override="false" value="---Key for Dictionary ---"/>
<Parameter name="tds.dictionary.url.TDS_Dict_SD4" override="false" value="http://www.dictionaryapi.com/api/v1/references/sd4/xml/"/>
<Parameter name="tds.dictionary.key.thesaurus" override="false" value="---Key for Dictionary ---"/>
<Parameter name="tds.dictionary.url.thesaurus" override="false" value="http://www.dictionaryapi.com/api/v1/references/ithesaurus/xml/"/>
<Parameter name="tds.dictionary.key.spanish" override="false" value="---Key for Dictionary ---"/>
<Parameter name="tds.dictionary.url.spanish" override="false" value="http://www.dictionaryapi.com/api/v1/references/spanish/xml/"/>

```
Note that the dictionary keys must be obtained and licensed from [Merriam-Webster](http://www.merriam-webster.com). If you are a Smarter Balanced vendor, you may contact [Smarter Balanced](http://www.smarterbalanced.org) for more information. 

The following parameter is optional in context.xml:
```
<Parameter name="tds.dictionary.groupName" override="false" value="SBAC"/>
```
If `groupName` for the Dictionary project is specified, then an appropriate database entry in the TDS database must be made. To do this, execute the following script in TDS:
```
INSERT INTO `configs`.`tds_applicationsettings` (`_key`, `environment`, `appname`, `property`, `type`, `isoperational`) VALUES ('660B3EAF-993B-4289-A2C9-28AB72B7B2CH', 'Development', 'Student', 'tds.dictionary.group', 'string', 1);
INSERT INTO `configs`.`system_applicationsettings` (`clientname`, `environment`, `appname`, `property`, `type`, `value`, `servername`, `siteid`, `_fk_tds_applicationsettings`)
VALUES ('SBAC', 'Development', 'Student', 'tds.dictionary.group', 'string', 'SBAC', '', '',(select _key from configs.tds_applicationsettings where property like '%tds.dictionary.group%'));
```

Additionally, this parameter must be added to the Program Management configuration for the Student component:

`tds.testshell.dictionaryUrl=http://<host>/Dictionary` - URL for the Dictionary project deployment.

### Build order

If building all components from scratch the following build order is needed:

* sharedmultijardev

## Dependencies

### Compile Time Dependencies

* shared-web
* spring-boot-starter-tomcat
* logback-classic
* jcl-over-slf4j

### Runtime Dependency

* servlet-api

### Test Dependencies
* junit
* shared-db-test