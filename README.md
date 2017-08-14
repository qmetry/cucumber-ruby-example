# cucumber-ruby-example

### Install Dependencies

Supported Ruby Version - 2.0+  

We are using these custom modules : selenium-webdriver, rest-client, json.

We have preconfigured `ruby` to automatically run `gems` so we can simply do:

```
gem install selenium-webdriver rest-client json 
```

### Install geckodriver  

You need to install [geckodriver](https://github.com/mozilla/geckodriver/releases) to run test on Mozilla. Then extract the downloaded file in a directory in the PATH.

### Run test

First you need to provide few details in Steps file. `features > step_definitions > search_steps.rb`. 

1. Select type of JIRA hosting - Cloud Or Server/On Primise/Data Center. 
2. Provide API key. You can get this value by logging inro your JIRA instance. Click on QMetry Menu on top -> Automation API. Here you can get API key of your selected project. 
3. If your JIRA hosting type is Server/Data Center then you need to set JIRA username and passoword too for REST API access.
4. And finally QMetry automation API URL - This value is also present in Automation API page.

After providing these details, you are ready to start test.

```
cucumber --format json_pretty > cucumber.json
```

It will generate cucumber.json test result file. 

Addionally, right after test completion, test result file will be uploaded on your JIRA instance. 
