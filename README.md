#README

This application requires:

- Ruby 2.4.1
- Rails 5.2.0

Required system packages
---------------
This is not an exhaustive list, feel free to add more as you find them.
* Ruby, preferably with a Ruby version manager such as rvm or rbenv
* MongoDB
* `sudo apt-get install libgeos-dev`
* `sudo apt-get install libproj-dev`
Getting Started
---------------
1. Install the correct version of Ruby with bundle, then run `bundle` to install all the Gemfile requirements
2. Run `rails generate simple_form:install`
4. Run `rails ingest_all:geojsons_task`
5. Create an Admin user with the console

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Databases
	City Boundaries
									has_many						has_one
		* Department ----------> Levels ----------> Geometry
					     							|has_many
					        					----------> Numpoint Distributions
	Public Assets
												has_many							has_many									 has_many										has_many
		* ServiceCaategory ----------> Services -----------> ServiceMetrics ----------> ServiceAssets ------------> Geometry

								  has_many
		* Grievance ------------> Geometry

* Data ingestion instructions
	# To import Geojsons into DB
	rails ingest_all:geojsons_task
