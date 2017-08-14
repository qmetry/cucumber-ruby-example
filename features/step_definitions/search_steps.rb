# Vaibhavsinh Vaghela
# July 27th, 2017

=begin

Automated Ruby script that navigates to Agiletrailblazers, search for word 'agile', and
then the results for the search will be displayed. Designed for Firefox on macOS.

=end

require "selenium-webdriver"
require "rest-client"
require "json"
require "selenium-webdriver" 
require "base64"
require 'uri'
require 'net/http'


#This variable needs to be set by the user: 

#TODO 1 - Set JIRA hosting type - Cloud(C) or Server/Data-center (S)
installation_type="C"

#TODO 2 - Set API Key - Copy from QMetry-> Automation API page. 
apiKey="5a279c7273de04e7b41e95ff2114d797704a4682a71bc89bbe667a6c89bbe667"

#required in QMetry Server Addon
userCredentials="username:password"

#import result API url
url="https://importresults.qmetry.com/prod/importresults-qtm4j"

#driver variable for firefox webdriver
driver = Selenium::WebDriver.for :firefox

#Navigates to the homepage.
Given(/^We navigate to the QMetry WebSite$/) do
  driver.navigate.to "http://www.qmetry.com/"
end

#Search for word agile in there
When(/^We search for the word qmetry automation framework$/) do
  driver.find_element(:id, 's').send_keys("qmetry automation framework")
  driver.find_element(:id, 'searchsubmit').click
end

#The result for the search will be displayed
Then(/^The results for the search will be displayed$/) do
  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
  begin
    element = wait.until { driver.find_element(:class => "search_result") }
    #expect(element.text).to eq('Search Results for: qmetry automation framework')
  ensure
    driver.quit
  end
end

#Upload result to JIRA using QMetry rest api.
After do

  if installation_type == "C"  
    puts "-------Import Results--------"

    #Replace this with 
    data = {
        apiKey: apiKey,
        format: 'cucumber/json',
        testRunName: 'New Test Run created from sample cucumber ruby project'
    }.to_json

    response = RestClient.post url, data, {:content_type => :json}

    puts response.code
    puts response.body 

    puts "-------Upload File--------"

    json_data = JSON.parse response.body # String -> JSON object (Hash).
    RestClient.put json_data["url"], File.read(File.join(File.dirname(__FILE__), '../../','cucumber.json')), :content_type => "multipart/form-data"

    puts "Upload done."

  else 
    credentials = userCredentials
    encoding = Base64.encode64 credentials
    encoded = "Basic #{encoding}"
    request = {

        :apiKey => apiKey,
        :format => "cucumber/json",
        :file => {

            :multipart => true,
            :file => File.open(File.join(File.dirname(__FILE__), '../../','cucumber.json'), 'rb')

        }
    }

  begin
      # The POST request.
      result = RestClient.post(url, request, "Authorization" => encoded)
      puts result
  rescue => e
      puts e.response
  end
  end
end