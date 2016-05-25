## CCTconverterApp
###### Ruby  app  for  obtaining  FX  rates. Acces with Ruby on Rails
* Ruby 2.1.7
* Rails 4.2.4
* sqlite3
* csv2sqlite (https://github.com/dergachev/csv2sqlite)

###### Instructions
* Download repository and extract
* Enter the Rails application under CCTconverterApp/ and run in terminal 
```
rake db:migrate
```
* Go back to the main folder where the 'updateApp.sh' file is and run in terminal
```
./updateApp.sh
```
* Enter the Rails application again under CCTconverterApp/ and run in terminal
```
rails s
```
* It will be running in localhost. To visit the App navigate in your browser to 
**localhost:3000**