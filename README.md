# Book Club

This is a student project from the Turing School of Software & Design as part of the Module 2 backend engineering curriculum.  The purpose of this project was to build an application with Ruby on Rails that allows users to browse and review books.  It is seeded with data for presentation purposes, however, it is fully functioning to add or remove books and book reviews.  

It tested our abilities to setup a database with many-to-many relationships and implement CRUD functionality.  The project was completed utilizing test-driven development and organized with a MVC structure.

- View it live [here](https://book-club-reviews.herokuapp.com/)  
- View the original assignment [here](https://github.com/turingschool-projects/BookClub)
- Team members: [Matt Levy](https://github.com/milevy1) & [Vincent Provenzano](https://github.com/Vjp888/)

## Built With

* [Ruby on Rails 5.1.6](https://rubyonrails.org/) - Web Framework
* [PostgreSQL](https://postgresapp.com/) - Database Management System

### Database Schema
<img src='./app/assets/images/db_schema.png' width='700px'>

### Screenshot of Books index page
<img src='./app/assets/images/book_index_screenshot.png' width='700px'>

### Installing

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

- From your terminal, clone the repo: ```git clone git@github.com:Vjp888/book_club.git```
- If you do not have PostgreSQL, follow the steps to setup PostgreSQL [here](https://postgresapp.com/)
- Move to the new project directory: ```cd book_club```
- Install required gems by running: ```bundle install```
- Seed the application with data by running: ```rake db:{drop,create,migrate,seed}```
- Start up your local Rails server by running: ```rails server```
- View the application in your browser

### Testing

RSpec was used for testing with gems Capybara and Shoulda-matchers.  Test coverage was tracked with SimpleCov.

- To run tests, from the root directory, run: ```rspec```

### Break down of tests

Tests in the spec/features folder test features simulating user interaction with the application and then expecting content on the page within specific CSS selectors.

Tests in the spec/models folder test the object models setup in the database.  They contain validations for table attributes, table relationships, and also methods built with ActiveRecord to interact with the database.
