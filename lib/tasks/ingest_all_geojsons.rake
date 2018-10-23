namespace :ingest_all do
  desc "Place the ingestion rakes here and run it to run all those tasks"

  task :geojsons_task => :environment do
  	# jurisdiction boundry
  	puts "Importing jurisdiction boundries"
		Rake::Task["import_geojsons:jurisdictions"].invoke("GHMC Zones.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("GHMC Circles.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("GHMC Wards.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		# jurisdictional boundry HMWSSB
		puts "Importing jurisdiction boundries HMWSSB"
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Circles.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Divisions.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Sub-Divisions.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Boundaries.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		# basic service transport
  	puts "Importing basic-service transport"
		Rake::Task["import_geojsons:basic_services"].invoke("Hyderabad_bus_stops.geojson","public_transport","bus_stop")
		Rake::Task["import_geojsons:basic_services"].reenable
		Rake::Task["import_geojsons:basic_services"].invoke("Hyderabad_metro_stations.geojson","public_transport","metro_station")
		Rake::Task["import_geojsons:basic_services"].reenable
		Rake::Task["import_geojsons:basic_services"].invoke("Hyderabad_MMTS_stops.geojson","public_transport","mmts_stop")
		Rake::Task["import_geojsons:basic_services"].reenable
		# basic service roads
		# Rake::Task["import_geojsons:basic_services"].invoke("Hyderabad_Roads.geojson","roads","road")
		# Rake::Task["import_geojsons:basic_services"].reenable
    # Basic service Junctions
    Rake::Task["import_geojsons:basic_services"].invoke("Urban Junction Improvement Plan.geojson","roads","junctions")
		Rake::Task["import_geojsons:basic_services"].reenable
		#  basic service power
  	puts "Importing basic-service power"
		Rake::Task["import_geojsons:basic_services"].invoke("Locations_of_Power_Substations.geojson","power","power_substation")
    # Disaster Reilience
    Rake::Task["import_geojsons:disaster_resiliences"].invoke("Police Station Locations.geojson","disaster_response_services","police_stations")
    Rake::Task["import_geojsons:disaster_resiliences"].reenable
    Rake::Task["import_geojsons:disaster_resiliences"].invoke("Fire Station Locations.geojson","disaster_response_services","fire_station")
    Rake::Task["import_geojsons:disaster_resiliences"].reenable
    Rake::Task["import_geojsons:disaster_resiliences"].invoke("Private Arogyasri Empanelled DRS.geojson","disaster_response_services","arogyasri_empanelled")
    Rake::Task["import_geojsons:disaster_resiliences"].reenable
    Rake::Task["import_geojsons:disaster_resiliences"].invoke("Govt Hospitals DRS.geojson","disaster_response_services","govt_hospital")
    Rake::Task["import_geojsons:disaster_resiliences"].reenable
		# grievance and numpoint streetlight
  	puts "Importing streetlight grievance and numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Streetlight Grievances.geojson","streetlight")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Streetlight_grievances_across_zones.geojson","streetlight_grievance","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Streetlight_grievances_across_wards.geojson","streetlight_grievance","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Streetlight_grievances_across_circles.geojson","streetlight_grievance","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		# grievance and numpoint solid waste debris
  	puts "Importing solid-waste debris grievance and numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Construction Debris Issues.geojson","construction_debris")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Construction_debris_across_zones.geojson","construction_debris","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Construction_debris_across_circles.geojson","construction_debris","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Construction_debris_across_wards.geojson","construction_debris","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# grievance and numpoint solid waste garbage
  	puts "Importing solid-waste garbage grievance and numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Garbage Issues.geojson","garbage")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Garbage_issues_across_zones.geojson","garbage_issue","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Garbage_issues_across_circles.geojson","garbage_issue","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Garbage_issues_across_wards.geojson","garbage_issue","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# grievance and numpoint waste water drains
  	puts "Importing waste-water drains grievance and numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Drains_complaints.geojson","drainage")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Drains_complaints_across_zones.geojson","drainage","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Drains_complaints_across_circles.geojson","drainage","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Drains_complaints_across_wards.geojson","drainage","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# grievance and numpoint waste water manhole
  	puts "Importing waste-water manhole grievance and numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Manhole_grievances.geojson","manhole")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Manhole_grievances_across_zones.geojson","manhole","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Manhole_grievances_across_circles.geojson","manhole","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Manhole_grievances_across_wards.geojson","manhole","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# grievance and numpoint roads potholes
  	puts "Importing roads potholes and grievance numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Pothole Grievance Reports.geojson","pothole")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Potholes_across_zones.geojson","pothole","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Potholes_across_circles.geojson","pothole","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Potholes_across_wards.geojson","pothole","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# grievance and numpoint roads footpath
  	puts "Importing roads footpaths and grievance numpoints"
		Rake::Task["import_geojsons:grievances"].invoke("Roads_Footpath_grievances.geojson","footpath")
		Rake::Task["import_geojsons:grievances"].reenable
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Footpath_grievances_across_zones.geojson","footpath","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Footpath_grievances_across_circles.geojson","footpath","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("Footpath_grievances_across_wards.geojson","footpath","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# numpoints all public transport
  	puts "Importing all public-transport grievance numpoints"
		Rake::Task["import_geojsons:numpoints"].invoke("All_pub_transport_across_zones.geojson","all_public_transports","Zone")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("All_pub_transport_across_circles.geojson","all_public_transports","Circle")
		Rake::Task["import_geojsons:numpoints"].reenable
		Rake::Task["import_geojsons:numpoints"].invoke("All_pub_transport_across_wards.geojson","all_public_transports","Ward")
		Rake::Task["import_geojsons:numpoints"].reenable
		# urban_poverty health
		puts "Importing urban_poverty health"
		Rake::Task["import_geojsons:urban_poverty"].invoke("All affordable healthcare facilities.geojson","health","affordable_healthcare_centre")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		Rake::Task["import_geojsons:urban_poverty"].invoke("Basti Dawakhana.geojson","health","basti_dawakhana")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		Rake::Task["import_geojsons:urban_poverty"].invoke("Govt Hospitals.geojson","health","govt_hospital")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		Rake::Task["import_geojsons:urban_poverty"].invoke("Govt Primary Health Clinics.geojson","health","govt_phc")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		Rake::Task["import_geojsons:urban_poverty"].invoke("Private Arogyasri Empanelled.geojson","health","private_arogyasri")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		#  urban poverty education
		puts "Importing urban_poverty education"
		Rake::Task["import_geojsons:urban_poverty"].invoke("Affordable Schools (Govt _ Pvt Aided).geojson","education","school")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		# urban poverty public-toilets
		puts "Importing urban_poverty sanitation - public toilets"
		Rake::Task["import_geojsons:urban_poverty"].invoke("Public_Toilet_Locations.geojson","sanitation","public_toilet")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		# public toilet grievances
		puts "Importing urban poverty (public-toilets) grievances"
		Rake::Task["import_geojsons:grievances"].invoke("Toilet Grievances.geojson","public_toilet")
		Rake::Task["import_geojsons:grievances"].reenable
		#  urban poverty nutrition
		puts "Importing urban_poverty nutrition canteens"
		Rake::Task["import_geojsons:urban_poverty"].invoke("Rs 5 meal canteens.geojson","nutrition","meal_canteen")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		#  urban poverty Long term housing
		puts "Importing urban_poverty nutrition canteens"
		Rake::Task["import_geojsons:urban_poverty"].invoke("2BHK_Housing_Hyderabad.geojson","housing","long_term_housing")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		#  urban poverty Old age shelters
		puts "Importing urban_poverty nutrition canteens"
		Rake::Task["import_geojsons:urban_poverty"].invoke("Old Age Shelters.geojson","nursing_home","old_age_shelters")
		Rake::Task["import_geojsons:urban_poverty"].reenable
		# Public Resources
		puts "Importing Public Resources Musi river"
		Rake::Task["import_geojsons:general_data"].invoke("Musi River.geojson","river","musi_river")
		Rake::Task["import_geojsons:general_data"].reenable
		# Public Resources
		puts "Importing Public Resources Hyderabad Railways"
		Rake::Task["import_geojsons:general_data"].invoke("Hyderabad_Railways.geojson","railway","domestic_railways")
		Rake::Task["import_geojsons:general_data"].reenable
		# Public Resources
		puts "Importing Public Resources Hyderabad Waterways"
		Rake::Task["import_geojsons:general_data"].invoke("Hyderabad_Waterways.geojson","waterway","domestic_waterways")
		Rake::Task["import_geojsons:general_data"].reenable
  end
end
