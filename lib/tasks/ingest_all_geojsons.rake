namespace :ingest_all do
  desc "Place the ingestion rakes here and run it to run all those tasks"

  task :geojsons_task => :environment do
  	# jurisdiction boundry

  	# puts "Importing jurisdiction boundries - GHMC"
		# Rake::Task["import_geojsons:jurisdictions"].invoke("GHMC Zones.geojson")
		# Rake::Task["import_geojsons:jurisdictions"].reenable
		# Rake::Task["import_geojsons:jurisdictions"].invoke("GHMC Circles.geojson")
		# Rake::Task["import_geojsons:jurisdictions"].reenable
		# Rake::Task["import_geojsons:jurisdictions"].invoke("GHMC Wards.geojson")
		# Rake::Task["import_geojsons:jurisdictions"].reenable

    # OLD Import ward details for GHMC
    # puts "---> Importing Area ward Committees details"
    # Rake::Task["import_geojsons:import_ward_detail"].invoke("Area Sabhas.geojson","GHMC","Ward")
    # Rake::Task["import_geojsons:import_ward_detail"].reenable
    # Rake::Task["import_geojsons:import_ward_detail"].invoke("Ward Committees.geojson","GHMC","Ward")
    # Rake::Task["import_geojsons:import_ward_detail"].reenable
    # puts "---> Importing Population and expenditure"
    # Rake::Task["import_geojsons:import_ward_detail"].invoke("Ward Wise GHMC Expenditure - FY 2016-2017.geojson","GHMC","Ward")
    # Rake::Task["import_geojsons:import_ward_detail"].reenable

    # Import heatmap metrics GHMC
    puts "---> Importing heatmap metrics"
    Rake::Task["import_geojsons:import_heatmap_metric"].invoke(
      "Ward Wise GHMC Expenditure - FY 2016-2017.geojson",
      "total_ward_expenditure",
      "Total Ward Expenditure (In Rs.)",
      "Total Ward Expenditure (In Rs.)",
      "GHMC"
    )
    Rake::Task['import_geojsons:import_heatmap_metric'].reenable

    Rake::Task['import_geojsons:import_heatmap_metric'].invoke(
      'Ward Wise GHMC Expenditure - FY 2016-2017.geojson',
      'expenditure_population_ratio',
      'Expenditure/Population Ratio (In Rs.)',
      'Expenditure\/ Population Ratio (In Rs.)',
      'GHMC'
    )
    Rake::Task['import_geojsons:import_heatmap_metric'].reenable

    Rake::Task['import_geojsons:import_heatmap_metric'].invoke(
      'Ward Wise GHMC Expenditure - FY 2016-2017.geojson',
      'population',
      'Population',
      'Population',
      'GHMC'
    )
    Rake::Task['import_geojsons:import_heatmap_metric'].reenable

    raise "Exception for blocking everything else"
		# jurisdictional boundry HMWSSB
		puts "Importing jurisdiction boundries - HMWSSB"
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Circles.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Divisions.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Sub-Divisions.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable
		Rake::Task["import_geojsons:jurisdictions"].invoke("HMWSSB Boundaries.geojson")
		Rake::Task["import_geojsons:jurisdictions"].reenable

    ############################################################################
		# Basic Services
    ############################################################################
  	puts "Importing Basic Services"
    # Bus Stops
    puts "---> Importing Bus stop"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Hyderabad_bus_stops.geojson","basic_service","public_transport","bus_stop","bus_stop_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # MMTS stops
    puts "---> Importing MMTS stop"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Hyderabad_MMTS_stops.geojson","basic_service","public_transport","mmts_stop","mmts_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Metro stations
    puts "---> Importing Metro station"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Hyderabad_metro_stations.geojson","basic_service","public_transport","metro_station","metro_station_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    #  Power station
  	puts "---> Importing Power station"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Locations_of_Power_Substations.geojson","basic_service","power","power_substation","power_substation_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    #  Power substation breakdown
    puts "---> Importing Power substation breakdown"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Substation_power_breakdowns.geojson","basic_service","power","power_substation_breakdown","power_substation_breakdown")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    #  Power schedule maintenance
    puts "---> Importing Power schedule maintenance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Shceduled_maintenance.geojson","basic_service","power","power_scheduled_maintenance","power_scheduled_maintenance")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Streetlight Grievances
  	puts "---> Importing streetlight grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Streetlight Grievances.geojson","basic_service","streetlight","streetlight_grievance","streetlight_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Solid waste - Construction debris
  	puts "---> Importing solid-waste debris grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Construction Debris Issues.geojson","basic_service","solid_waste","construction_debris_grievance","construction_debris_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Solid waste - Garbage
  	puts "---> Importing solid-waste garbage grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Garbage Issues.geojson","basic_service","solid_waste","garbage_grievance","garbage_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Waste water -  Drainage
  	puts "---> Importing waste-water drains grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Drains_complaints.geojson","basic_service","waste_water","drainage_grievance","drainage_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Waste water - Manhole
  	puts "---> Importing waste-water manhole grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Manhole_grievances.geojson","basic_service","waste_water","manhole_grievance","manhole_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Junction location
    puts "---> Importing Junction location"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Urban Junction Improvement Plan.geojson","basic_service","roads","junctions","junction_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Roads - potholes
  	puts "---> Importing roads potholes and grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Pothole Grievance Reports.geojson","basic_service","roads","pothole_grievance","pothole_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Roads - footpath
  	puts "---> Importing roads footpaths and grievance"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Roads_Footpath_grievances.geojson","basic_service","roads","footpath_grievance","footpath_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Roads - Traffic chokepoint
  	puts "---> Importing roads traffic chokepoint"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Traffic choke points.geojson","basic_service","roads","traffic_choke_point","traffic_choke_point_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Parking Spaces
		puts "---> Importing Parking spaces"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Parking spaces.geojson","basic_service","parking_spaces","parking_spaces","parking_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Outer Ring Road
    puts "---> Importing Outer Ring Road"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("ORR.geojson","basic_service","roads","outer_ring_road","outer_ring_road_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # basic service roads
		# Rake::Task["import_geojsons:basic_services"].invoke("Hyderabad_Roads.geojson","roads","road")
		# Rake::Task["import_geojsons:basic_services"].reenable
    # Basic service Junctions

    ############################################################################
    # Importing Urban Poverty
    ############################################################################
    puts "Importing Urban Poverty"
    #  Affordable Schools
    puts "---> Importing Affordable Schools"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Affordable Schools (Govt _ Pvt Aided).geojson","urban_poverty","affordable_education","govt_aided_school","school_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Basti Dawakhana
    puts "---> Importing Basti Dawakhana"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Basti Dawakhana.geojson","urban_poverty","affordable_healthcare","basti_dawakhana","basti_dawakhana_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Affordable Health care
    puts "---> Importing Affordable healthcare"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("All affordable healthcare facilities.geojson","urban_poverty","affordable_healthcare","affordable_healthcare_centre","healthcare_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Govt Hospitals
    puts "---> Importing Govt Hospitals"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Govt Hospitals.geojson","urban_poverty","affordable_healthcare","govt_hospital","govt_hospital_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Govt Primary health clinic
    puts "---> Importing Govt Primary Health clinic"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Govt Primary Health Clinics.geojson","urban_poverty","affordable_healthcare","govt_phc","govt_phc_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Private Arogyasri Empanelled
    puts "---> Importing Private Arogyasri Empanelled"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Private Arogyasri Empanelled.geojson","urban_poverty","affordable_healthcare","private_arogyasri","private_arogyasri_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Kanti Velugu phase 1
    puts "---> Importing Kanti Velugu phase 1"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Kanti Velugu Phase-1.geojson","urban_poverty","health","kanti_velugu_phase_1","kanti_velugu_phase_1")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Kanti Velugu phase 2
    puts "---> Importing Kanti Velugu phase 2"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Kanti Velugu Phase-2.geojson","urban_poverty","health","kanti_velugu_phase_2","kanti_velugu_phase_2")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Public toilets
    puts "---> Importing Public toilets"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Public_Toilet_Locations.geojson","urban_poverty","sanitation","public_toilet","public_toilet_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # public toilet grievances
		puts "---> Importing public-toilets grievances"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Toilet Grievances.geojson","urban_poverty","public_toilet_grievance","public_toilet_grievance")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    #  Long term housing - 2BHK housing
    puts "---> Importing 2 BHK housing"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("2BHK_Housing_Hyderabad.geojson","urban_poverty","affordable_housing","long_term_housing","2bhk_housing_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    #  Short term housing - Old age shelters
    puts "---> Importing old age shelters"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Old Age Shelters.geojson","urban_poverty","affordable_housing","old_age_shelters","old_age_shelter_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Fair price shop
    puts "---> Importing Fair price shop"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Fair Price Shops.geojson","urban_poverty","nutrition","fair_price_shops","fair_price_shop")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    #  Rs 5 meal canteens
    puts "---> Importing urban_poverty nutrition canteens"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Rs 5 meal canteens.geojson","urban_poverty","affordable_nutrition","rs_5_meal_canteen","rs_5_meal_canteen_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable



    ############################################################################
    # Disaster Resilience
    ############################################################################
    puts "Importing Disaster Resilience"
    # Flood risk management
    puts "---> Importing Vulnerable location"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Vulnerable Localities.geojson","disaster_resilience","flood_risk_management","vulnerable_localities","vulnerable_locality")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Rehabilitation center
    puts "---> Importing Rehabilitation Centers"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Rehabilitation Centers.geojson","disaster_resilience","flood_risk_management","rehabilitation_center","rehab_center")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Pubs and bars
    puts "---> Importing Govt hospital"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Pubs and Bars for Inspection.geojson", "disaster_resilience","fire_risk_management","pubs_and_bars_for_inspection", "pubs_and_bars_location")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Fire Station
    puts "---> Importing Fire station"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Fire Station Locations.geojson","disaster_resilience","emergency_response_services","fire_station","fire_station_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Private Arogyasri Empanelled
    puts "---> Importing Private arogyasri empanelled"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Private Arogyasri Empanelled DRS.geojson","disaster_resilience","emergency_response_services","arogyasri_empanelled","arogyasri_empanelled_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Govt Hospital
    puts "---> Importing Govt hospital"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Govt Hospitals DRS.geojson","disaster_resilience","emergency_response_services","govt_hospital","govt_hospital_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Police Station
    puts "---> Importing Police station"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Police Station Locations.geojson","disaster_resilience","emergency_response_services","police_stations","police_stations_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Fire risk management
    puts "---> Importing Govt hospital"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Fire Station Locations.geojson","disaster_resilience","fire_risk_management","fire_station","fire_station_locations")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable


    # # Hyderabad countours
		# puts "---> Importing Hyderabad Countours"
		# Rake::Task["import_geojsons:disaster_resiliences"].invoke("Hyderabad Countours.geojson","flood_risk_management","hyderabad_countours")
		# Rake::Task["import_geojsons:disaster_resiliences"].reenable
		# # Stream Segments
		# puts "---> Importing Stream Segments"
		# Rake::Task["import_geojsons:disaster_resiliences"].invoke("Stream Segments.geojson","flood_risk_management","stream_segments")
		# Rake::Task["import_geojsons:disaster_resiliences"].reenable


    ############################################################################
    # Governance
    ############################################################################
    puts "Importing Governance"
    # Importing population and expenditure



    ############################################################################
    # Economy
    ############################################################################
    puts "Importing Economy"
    # Business density
		puts "---> Importing Business Density markers"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Commercial & Industrial Buildings and Zones (points).geojson","economy","commercial_buildings","business_density","business-density-markers")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable



    ############################################################################
    # Environment
    ############################################################################
    puts "Importing Environment"
    # Public resource parks
    puts "---> Importing GHMC_HMDA Parks"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("GHMC _ HMDA Parks.geojson","environment","ghmc_jurisdiction_parks","ghmc_hmda_parks","parks")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Public resource parks
    puts "---> Importing Crowdsourced Parks"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Parks - Crowdsourced.geojson","environment","crowd_sourced_parks","crowd_sourced_parks","parks")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Haritha haram
		puts "---> Importing Haritha haram location wise"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Haritha Haram- Location-Wise Plants Planted.geojson","haritha_haram","green_cover","planted_plants","plants")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Haritha haram
		puts "---> Importing Haritha haram nurseries locations"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Haritha Haram List of Nurseries - 2017.geojson","haritha_haram","green_cover","nurseries","plants")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Public Landfill pollution
    puts "---> Importing Landfill dump yard area"
    Rake::Task["import_geojsons:ingest_service_assets"].invoke("Landfills and Dumpyards Location.geojson","environment","landfill_pollution","landfill_pollution","landfill_location")
    Rake::Task["import_geojsons:ingest_service_assets"].reenable

    # # Noise Pollution Daytime
		# puts "---> Importing Noise Day-time Pollution"
		# Rake::Task["import_geojsons:environment_data"].invoke("2018 Jan-June Noise Pollution - Day-Time.geojson","day_time_noise_pollution","pollution")
		# Rake::Task["import_geojsons:environment_data"].reenable
		# # Noise Pollution Night time
		# puts "---> Importing Noise Night-time Pollution"
		# Rake::Task["import_geojsons:environment_data"].invoke("2018 Jan-June Noise Pollution - Night-Time.geojson","night_time_noise_pollution","pollution")
		# Rake::Task["import_geojsons:environment_data"].reenable



    ############################################################################
    # General Data
    ############################################################################
    puts "Importing General Dataset"
    # Musi river
		puts "---> Importing Musi river"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Musi River.geojson","general_dataset","general_data_layer","musi_river","river")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Railwaylines
		puts "---> Importing Railways"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Hyderabad_Railways.geojson","general_dataset","general_data_layer","railway_line","domestic_railways")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
		# Waterways
		puts "---> Importing Hyderabad Waterways"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Hyderabad_Waterways.geojson","general_dataset","general_data_layer","waterway","domestic_waterways")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable
    # Water Bodies
		puts "---> Importing Hyderabad Waterbodies"
		Rake::Task["import_geojsons:ingest_service_assets"].invoke("Waterbodies.geojson","general_dataset","general_data_layer","water_bodies","domestic_waterways")
		Rake::Task["import_geojsons:ingest_service_assets"].reenable


  end
end
