# Freefrom Compensation Backend

## Overview
FreeFrom is a nonprofit dedicated to helping survivors of domestic violence achieve financial stability. On their website they have a [compensation tool](https://compensation-quiz.freefrom.org/) where users can answer a series of questions in order to get information about financial resources that are available to them depending on their state.

This repository contains the new Rails backend for the compensation tool and the CMS that allows FreeFrom administrators to change the content in the tool.

## Local Development Setup
### Install Ruby
Make sure you have ruby version 2.6.3 installed on your local machine, or install it using this guide: https://www.ruby-lang.org/en/documentation/installation/

### Install PostgreSQL
Install and run a PostgreSQL version 11.4.

### Set up database roles
1. Start a Postgres client session: `psql`
2. Create a new user: `create user "freefrom-compensation-api-user";`
3. Give that user special permissions: `alter user "freefrom-compensation-api-user" with superuser;`
4. Exit out of the client session: `exit`

### Install Rails
Run the command `gem install rails` (make sure `rails --version` returns 5.2.3)

### Set up app
1. Clone this repository onto your local machine
2. `cd` into the `freefrom-compensation-api` folder
3. Run `bundle install` to install the app's dependencies (run `gem install bundler` if that doesn't work)
4. Run `rake db:setup` to create the test and development databases
5. Run `rake db:migrate` to set up the necessary database tables
6. Run `bundle exec rails s` to start the server

To contribute, see [CONTRIBUTING.md](./contributing.md)