# HHS EWITS 2.0 CDC BizFlow HR Workflow System

Update History:
> ***Created by Taeho Lee on June 6, 2018***
***Updated by Taeho Lee on June 19, 2018*** - build instruction
----------


## 1. System Components
Source Repository: *https://github.com/HHS/CDC-BizFlow* This repository includes directories below.

| Directory | Description |
|-----------|-------------------------------|
|database   | `Database scripts; DDL, Permission, Stored Procedure, Functions, and Populating records in HHS_CDC_HR, HHS_HR, Workflow database` |
|deploy     | `Build script for DevOps` |
|java       | `Custom-developed Java module` |
|process    | `Process definition, user group, BizCove/View/Menu` |
|release    | `snapshot of released version` |
|report     | `BizFlow Advance Report export file` |
|UAT        | `User Acceptance Test related files` |
|webapps    | `Web application, including BizFlow web solution, WebMaker runtime directory` |
|ui         | `User Interface forms. WebMaker, JSP, Angular` |


----------

## 2. Build Instruction

### Pre-requisite
 - JDK 1.7 
 - Apache Ant 1.9.x
 - Git
 - Github account
 
> **Notes:** As of April 2nd 2018, the official **JDK**  is not 1.8.x but **1.7.x**. All HHS HR workflow (EWITS 2.0) applications will be deployed to a shared environment having 1.7.x 64bit. **Ant** will be official build tool across all HHS HR workflow applications. If you are using **Maven** or **Gradle** to build your code, you must create an Ant build script too.

### Build Steps

#### build bizflowrule.war
1. open command prompt
2. go to java/bizflowrule directory
3. run ANT build script
>ant
4. Capture the generated war file
>java/bizflowrule/out/bizflowrule.war
5. Deploy the war file onto the target BizFlow WebMaker Tomcat location
><tomcat_dir>/webapps/

#### Export BizFlow BIX
1. Open BizFlow Process Studio
2. Log into BizFlow QA server
3. Click on the Export button
4. Select file path and enter export name
5. Expand Operational Environment in the Export Wizard
6. Move Menu/CDC Job Request(CDC) menu to the Selected Export Items
7. Move User Group/User Configuration/User Group/CDC to the Selected Export Items
8. Move Process Execution/Process Definition/Process Definitions/CDC to the Selected Export Items
9. Move Process Execution/Application/Application/CDC to the Selected Export Items
10. Move Component Library/Global Variable/Global Variable/cdcEmailDisclaimer to the Selected Export Items
11. Move Component Library/Global Variable/Global Variable/adminEmailAddress to the Selected Export Items 
12. Click on the Finish button.
13. Review the log to see if any error exists.
14. Check if an export file created in the folder.

#### Export BizFlow Reports
1. Go to Development Server to export reports
2. Go to buildomatic directory
> ex) C:\Program Files (x86)\BizFlowReporting\buildomatic
3. Create a "export" folder if not exists.
> ex) C:\Program Files (x86)\BizFlowReporting\buildomatic\export
4. Export reports with command below
> js-export --output-zip ./export/CDCReports.zip --uris   /organizations/organization_1/reports/CDC/CDC_OF8
5. Capture the generated export zip file.



## 3. UI Module Packaging Instruction
UI modules are captured from DEV environment's web application directory, using ANT build file.

The ANT build file will package the UI modules in a zip file. Especially for WebMaker runtime files, the script will capture configuration files separately per environment, which will be deployed to the target environment appropriately by the deployment script later on. The script also appends timestamp to the JavaScript and CSS file references in the web application files so that the web browser cache is forced to be refreshed at the first time loading after the new deployment.

### Pre-requisite on DEV Server:
-   JDK/JRE 1.7
-   Apache Ant 1.9.x or later
-   Administrator (or sudo) access to DEV server machine
-   UI modules are deployed and tested in DEV server, and ready for promotion to higher environments (e.g. QA, PROD)
    -   WebMaker form runtime files
    -   bizflowrule.war file
    -   BizFlow solutions files

### Packaging Steps

1.  Login to DEV server machine with an administrator (or sudo) account.
    
2.  In the command line prompt, create a work directory where files will be generated, and change directory to it.
    
    For example:
    
    ```
     mkdir -p work/deploy
     cd work/deploy
    
    ```
    
3.  Copy UI packaging script to the deployment directory.
    
    -   From (source repository):
        -   deploy/build.xml
    -   To (target environment):
        -   <DEV_server_dir>/work/deploy/
4.  Using a text editor, modify the following property value in the  `build.xml`  file for tomcat web application directory setting. Specify the full path to the tomcat directory.
    
    ```
     <property name="webserver.dir" value="full_path_to_tomcat_directory" />
    
    ```
    
5.  In the command line prompt, run ANT. The following will execute the default target, which will generate a zip file.
    
    ```
     ant
    
    ```
    
6.  Capture the generated zip file. The packaging script will create the intermediate directories and generate the UI runtime zip file with timestamp suffix.
    
    For example:
    
    ```
     <DEV_server_dir>/work/deploy/deployment/ui/cdc_runtime_201800619_132525.zip
    
    ```


## 4. UI Module Deployment Instruction

UI modules are deployed to the higher environments (e.g. QA, PROD) using shell scripts.

The deployment script will stop tomcat service, copy runtime files to tomcat web application directory, and start tomcat service.

1.  Login to higher environment server machine with an administrator account. (Or, sudo to administrator account)
    
2.  In the command line prompt, create a work directory where the deployment package file will be placed, and change directory to it.
    
    For example:
    
    ```
     mkdir -p work/deploy/baseline/ui
     cd work/deploy
    
    ```
    
3.  Copy UI deployment script to the deployment directory.
    
    -   From (source repository):
        -   deploy/deploy_ui_qa.sh
    -   To (target environment):
        -   <DEV_server_dir>/work/deploy/
 
4.  Using a text editor, modify the following property value in the build.xml for tomcat web application directory setting. Specify the full path to the tomcat directory.
    
    ```
     DIR_DEPLOY=<full_path_to_deploy_baseline_directory_above>
     DIR_TOMCAT=<full_path_to_tomcat_directory>
    
    ```
    
5.  In the command line prompt, make the UI deployment script mode executable.
    
    For example:
    
    ```
     chomod 744 deploy_ui_qa.sh
    
    ```
    
6.  Copy UI deployment package file to the UI deployment directory.
    
    For example:
    
    -   From (source repository):
        -   cdc_runtime_20180619_132525.zip
    -   To (target environment):
        -   <DEV_server_dir>/work/deploy/baseline/ui

7.  In the command line prompt, extract the UI runtime zip file. If there is previous extract of runtime files, remove it before fresh extract.
    
    For example:
    
    ```
     cd baseline/ui
     rm -rf runtime
     unzip runtime_20180201_132525.zip
    
    ```
    
8.  In the command line prompt, change directory back to the deployment directory, and run the deployment script.
    
    For example:
    
    ```
     cd <DEV_server_dir>/work/deploy
     ./deploy_ui_qa.sh -nodebug
    
    ```
    
    Note: The deployment script has "-nodebug" option for real deployment action. If you run the script without the option, it will try to test directory setting without actually deploying any file. This is a precautionary measure to prevent accidental overwriting of the target application files. In order to run the deployment script in "DEBUG" mode, i.e. without "-nodebug" option, a dummy script should be placed in the deployment directory. Make sure the dummy script mode is executable.
    
    For example:
    
    -   From (source repository):
        -   deploy/script1.sh
    -   To (target environment):
        -   <DEV_server_dir>/work/deploy/

```
    chomod 744 script1.sh
```





