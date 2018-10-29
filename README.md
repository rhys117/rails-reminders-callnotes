# Reminder, Quick Copy and Call Note Generator.

This is a work in progress tool designed to manage work-flow within a call center roll with upstream provider and internal system references. This web application has been developed with a particular companies work-flow already in mind.

* This project and readme are still incomplete and are a work in progress.

To get started with the app, clone the repo and then install the needed gems:
```
$ bundle install
```

Next, migrate the database:
```
$ rails db:migrate
```
# Todo
- Migrate login to Devise
- Fix textareas JS for dynamically on form
- Finish tests for Reminders/call notes
- Move notes text from out of site textareas to JS Gon objects
- Implement v2 of call notes (genreate off of JSON)
- Create React frontend for call notes and call path flow
- Update readme with component nested template documentation 
- Overhaul UI to be more user appealing


# Configuration
* Please note the below files need to be configured or you'll encounter errors. They are not currently created by default.
## Signup
Please note by default this program will need a sign up secret for new users. This should be placed in a sign_up.yml file in the /config directory with the variable name of 'secret'. eg.

/config/sign_up.yml
```
secret: sign_up_secret
```

## Reminder URLS
The reminders use reference, and service type hyper-links to direct the user to relevant work-flow. This should be placed in a urls.yml file in the /config directory with the variable name names of 'reference_url', 'vocus_url' and 'nbn_url' eg
```
reference_url: https://ticketsytem.com/Ticket/Display.html?id=
vocus_url: https://externalsource.com/view_ticket.php?id=
nbn_url: https://www.nbnco.com.au/?search=
```

## Call Note Templates
This was designed with text based templates already in mind. As such it was built to interpret existing designs.  

The call note generator will take templates and create a form based on their contents. When a user makes a selection it will edit the content of a textarea below dynamically with javascript.

Call note templates should be placed in a categories subdirectory folder in the app/assets/templates directory. There should be enquiry and work yaml files placed in each category which the note generator form parser will read from.  

Each yaml file should include the name of the templates as the variable name and the template afterwards as a string.

The web application will parse the the string and create a form based on it's contents. If the line includes a colon ':' the application will determine it is a question and create a form element based on the content afterwards. If a colon is not present the application will interpret the line as a statement. It will include this line but won't make a form element as it is not interpreted as question.

If nothing is included after the colon the application will create a textbox for the user to input data. If a textbox is not sufficient you can type textarea after the colon and the form will include a textarea instead.

To create radio buttons or select fields type answers after the colon separated by a forward slash '/'.

Please note the style of which in the below examples

/lib/generator_templates/enquiry/fibre.yml
```
No Optical Connection: |
  Customer calling to report no connection with optical impairment
  Serial number of customers device:
  Detailed Summary of issue: textarea
  What is the color of the optical light on the customers device: Off/Solid Green/Flashing Green/Solid Yellow/Flashing Yellow
  Informed customer of expected timeframe for resolution: yes/no
```

# Usage
## Reminders
On the home page once logged in, you'll be able to view current reminders and create new ones with the form on the bottom of the page. Future reminders will not be viewed on the home page however can be found in the 'Reminders' > 'All' link in the navigation bar.

## Quick Copy
If you wish to add quick copy buttons you which will display on the left of the home page. Navigate to 'Quick Copy' > 'New'. Give your quick note, a catergory, name and content. The name of the quick copy will appear below it's category on the home page. When clicked the content of the quick copy will be placed in the clipboard of the user.
