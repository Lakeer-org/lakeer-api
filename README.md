# Lakeer Backend #

[![Deployment Status](https://app.cloud66.com/stacks/badge/72a0eed0e22e03c20ca18069cc4d51fa.svg)](https://app.cloud66.com/stacks/54903)
(staging)

The main components of this application are:

Ruby  version - 2.4.1

Rails version - 5.2.0

Mongo DB version - 4.0.1

AWS S3 for storing geojson files

### API Structure

* The API is based on REST Architecture
* The GRAPE Framework is used to build the API
* Documentation is managed via swagger - http://jaguar.lakeer-production.c66.me/swagger


### Gem dependencies / System dependencies

You will have to install first and then the gem needs to be installed

```
sudo apt-get install libgeos-dev
sudo apt-get install libproj-dev
```

### Database creation and seeding data

```
rails db:migrate
rails ingest_all:geojsons_task
```

The above command should setup the database with all required data seeded for the application to run. If any additional geojson data to be added, First place the geojson file into S3 then run the following

```
rake import_geojsons:ingest_service_assets["Hyderabad_bus_stops.geojson","basic_service","public_transport","bus_stop","bus_stop_location"]
```

### Admin

A user with admin role needs to be created on the console first time.

Services (job queues, cache servers, search engines, etc.)

### Deployment instructions
The application is deployed to the AWS EC2 instance, Which is managed by cloud66.
