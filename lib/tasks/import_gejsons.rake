require 'json'
require 'fileutils'
require 's3_file_fetch'
include S3FileFetch

# IMPROVEMENTS
# HOOK FOR RAKE TASK
# TEMPORARY FILE FLUSHING MECHANISM

namespace :import_geojsons do
  desc "Files will be fetched from an aws bucket and ingested on the database"

	task :jurisdictions, [:filename]  => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	    department = Department.where(name: geojson["name"].split(" ").first, crs: geojson["crs"]).first_or_create
	    geojson["features"].each_with_index { |feature, index|
	    type = geojson["name"].split(" ").last.singularize
	    if type.eql?("Circle") && department.name.eql?("GHMC")
	    	circle_name = feature["properties"]["CIR_NAME"]
	    	circle_name = circle_name.split('-').last if /\d?/.match(circle_name)
	    	circle_number = feature["properties"]["CIR_NO"]
	    	circle_number = circle_number.split('-').last if /\d?/.match(circle_number)
		    level = department.levels.create(level_type: type,
		    										 						 name: circle_name,
		    										 						 level_number: circle_number)
		  elsif type.eql?("Ward")
		  	ward = feature["properties"]["ward"]
		  	ward = ward.split('-') if /\d?/.match(ward)
		  	circle = feature["properties"]["CIRCLE"].split('-').last
		  	level = department.levels.create(level_type: type,
		  																	 name: ward.last,
		  																	 level_number: ward.first,
		  																	 circle: circle,
		  																	 zone: feature["properties"]["ZONE"])
		  elsif type.eql?("Zone")
		  	level = department.levels.create(level_type: type,
		  																	 name: feature["properties"]["new_zones"])

	  	elsif type.eql?("Boundary")
	  		level = department.levels.create(level_type: type,
	  																		 name: feature["properties"]["Name"])

			elsif type.eql?("Sub-Division")
				level = department.levels.create(level_type: type,
																				 name: feature["properties"]["Name"])

  		elsif type.eql?("Division")
  			division = feature["properties"]["Name"]
  			division = division.split('-') if /\d?/.match(division)
  			level = department.levels.create(level_type: type,
																				 name: division.last,
																				 level_number: division.first)

	  	elsif type.eql?("Circle") && department.name.eql?("HMWSSB")
	  		circle = feature["properties"]["Name"]
	  		circle = circle.split('-') if /\d?/.match(circle)
	  		level = department.levels.create(level_type: type,
	  																		 name: circle.last,
	  																		 level_number: circle.first)

		  end
	    level.create_geometry feature["geometry"]
	     }
	  end
	 	# FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

  # Import ward detail like population, expenditure, chairperson, members, operational wards.
	task :import_ward_detail, [:filename, :department_name, :level_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	    geojson["features"].each do |feature|
	    	department = Department.find_by(name: args[:department_name])
    		ward = feature["properties"]["ward"] || feature["properties"]["Ward Name"]
    		ward = ward.split('-').last if /\d?/.match(ward)
        if ward
      		level = department.levels.where(level_type: args[:level_type]).find_by(name: ward)
          level.update(population: feature["properties"]["Population"]) if feature["properties"]["Population"].present?
          level.update(total_expenditure: feature["properties"]["Total Ward Expenditure (In Rs.)"]) if feature["properties"]["Total Ward Expenditure (In Rs.)"].present?
          level.update(expenditure_population_ratio: feature["properties"]["Expenditure/ Population Ratio (In Rs.)"]) if feature["properties"]["Expenditure/ Population Ratio (In Rs.)"].present?
          level.update(chairperson: feature["properties"]["Chairperson"]) if feature["properties"]["Chairperson"].present?
          level.update(area_sabha_members: feature["properties"]["Members"]) if feature["properties"]["Members"].present?
          level.update(person_nominated: feature["properties"]["Name of the person nominated"]) if feature["properties"]["Name of the person nominated"].present?
          level.update(no_of_operational_ward: feature["properties"]["Number of Operational wards"]) if feature["properties"]["Number of Operational wards"].present?
        else
          puts "Ward not present"
        end
		  end
	  end
	  # FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

  task :import_heatmap_metric, [:filename, :name, :display_name, :attr_key, :department] => :environment do |t, args|
    # filename: Name of the file in the AWS bucket that this can be loaded
    # name: Code friendly name that the metric will have
    # display_name: User friendly name that will be used in the UI
    # attr_key: Key that this metric has on the source geojson file
    # department: Whether GHMC or the other one
    path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))

    if geojson.has_key? "features"
      features = geojson["features"].map do |feature|
        {
          type: feature['type'],
          properties: {
            location: {
              ward: feature["properties"]["ward"],
              circle: feature["properties"]["CIRCLE"],
              zone: feature["properties"]["ZONE"]
            },
            value: feature["properties"][args.attr_key]
          },
          geometry: feature['geometry']
        }
      end
      Heatmap.create(
        name: args.name,
        display_name: args.display_name,
        type: geojson["type"],
        crs: geojson["crs"],
        department: args.department,
        metric_type: 'heatmap',
        features: features
      )
	   end
    flush_temporary_file(path)
  end


	task :haritha_haram, [:filename, :department_name, :level_type]  => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	    department = Department.where(name: args[:department_name], crs: geojson["crs"]).first_or_create
	    geojson["features"].each_with_index { |feature, index|
	    	ward = feature['properties']['ward'].split('-')
	    	circle = feature['properties']['CIRCLE'].split('-').last.downcase
	  		level = department.levels.create(level_type: args[:level_type],
	  																		 name: ward.last.downcase, ward: ward.last.downcase, level_number: ward.first,
	  																		 circle: circle, properties: feature['properties'])
	    	level.create_geometry feature["geometry"]
	    }
	  end
	 	# FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

	task :basic_services, [:filename, :service_type, :asset_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	  	service_category = ServiceCategory.where(name: 'basic_service').first_or_create
	  	service = service_category.services.where(service_type: args[:service_type]).first_or_create
	  	if geojson["name"]
	  		metric_name = geojson["name"].downcase.tr(' ', '_')
  		else
  			metric_name = "power_substations"
  		end
	  	metric = service.service_metrics.create(name: metric_name, crs: geojson["crs"])
	    geojson["features"].each do |feature|
        if feature["properties"]["Junction"].present?
          name = feature["properties"]["Junction"]
        else
          feature["properties"].values[1]
        end
	    	asset = metric.service_assets.create(asset_id: feature["properties"].values[0],
	    																			 name: name,
	    																			 location: feature["geometry"].present? ? feature["geometry"]["coordinates"] : nil,
													 									 asset_type: args[:asset_type])
    		asset.create_geometry feature["geometry"]
		  end
	  end
	  # FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

  task :disaster_resiliences, [:filename, :service_type, :asset_type] => :environment do |t, args|
  	path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	  	service_category = ServiceCategory.where(name: 'disaster_resiliences').first_or_create
	  	service = service_category.services.where(service_type: args[:service_type]).first_or_create
	  	if args[:service_type].include?("risk_management")
	  		metric_name = args[:asset_type]
	  		asset_type = args[:service_type].gsub("_risk_management", "")
	  	elsif geojson["name"]
	  		metric_name = geojson["name"].downcase.tr(' ', '_')
  		end
	  	metric = service.service_metrics.create(name: metric_name, crs: geojson["crs"])
	    geojson["features"].each do |feature|
        if feature["properties"]["Firestation"].present?
          name = feature["properties"]["Firestation"]
        elsif feature["properties"]["Police Station"].present?
          name = feature["properties"]["Police Station"]
        elsif feature["properties"]["Hospital name"].present?
          name = feature["properties"]["Hospital name"]
        else
          name =  feature["properties"].values[1]
        end
        properties = Hash.new
        feature['properties'].each do |key, value|
        	subbed_key = key.gsub('.', '')
        	properties[subbed_key] = value
        end
        # if args[:asset_type].include?("rehabilitation_centers")
        # 	properties = feature['properties'].except("Name of the incharge person with Mobile No.")
        # else
        # 	properties = feature['properties']
        # end
	    	asset = metric.service_assets.create!(asset_id: feature["properties"].values[0], name: name, location: feature["geometry"].present? ? feature["geometry"]["coordinates"] : nil, asset_type: asset_type.present? ? asset_type : args[:asset_type], properties: properties)
    		asset.create_geometry feature["geometry"]
		  end
	  end
	  # FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

		task :urban_poverty_health, [:filename, :service_type, :asset_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
		  if geojson.has_key? "features"
		  	service_category = ServiceCategory.where(name: 'urban_poverty').first_or_create
		  	service = service_category.services.where(service_type: args[:service_type]).first_or_create
		  	metric = service.service_metrics.create(name: geojson["name"].downcase.tr(' ', '_'), crs: geojson["crs"])
		    geojson["features"].each do |feature|
		    	asset = metric.service_assets.create(properties: feature["properties"].except("S.NO", "path", "layer"),
    																					 asset_type: args[:asset_type])
	    		asset.create_geometry feature["geometry"]
			  end
		  end
		 	# FLUSH TEMPORARY FILE
	  	flush_temporary_file(path)
		end

# ALL THESE URBAN POVERTY TASKS NEED TO BE CONSOLIDATED
	task :urban_poverty_nutrition, [:filename] => :environment do |t, args|
	path = fetch_file(args.filename)
	geojson = JSON.parse(File.open(path).read)
	basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	  	service_category = ServiceCategory.where(name: 'urban_poverty').first_or_create
	  	service = service_category.services.where(service_type: "nutrition").first_or_create
	  	metric = service.service_metrics.create(name: geojson["name"].downcase.tr(' ', '_'), crs: geojson["crs"])
	    geojson["features"].each do |feature|
	    	circle = feature["properties"]["CIRCLE"]
	    	circle = circle.split('-').last if /\d?/.match(circle)
	    	ward = feature["properties"]["WARD"]
	    	ward = ward.split('-').last if /\d?/.match(ward)
	    	asset = metric.service_assets.create(properties: feature["properties"],
	    																			circle_name: circle,
    																				ward_name: ward,
  																					asset_type: "rs_5_meal_canteen")
    		asset.create_geometry feature["geometry"]
		  end
	  end
	  # FLUSH TEMPORARY FILE
  	flush_temporary_file(path)
	end

	task :ingest_service_assets, [:filename, :service_name, :service_type, :metric_name, :asset_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	  	service_category = ServiceCategory.where(name: args[:service_name]).first_or_create
	  	service = service_category.services.where(service_type: args[:service_type]).first_or_create
	  	metric = service.service_metrics.create(name: args[:metric_name], display_name: args[:metric_name].titleize, crs: geojson["crs"])
	    geojson["features"].each do |feature|
	    	circle = feature["properties"]["CIRCLE"]
	    	ward = feature["properties"]["WARD"]
        properties = Hash.new
        feature['properties'].each do |key, value|
        	subbed_key = key.gsub('.', '')
        	properties[subbed_key] = value
        end
	    	asset = metric.service_assets.create(properties: properties,
	    																			location: feature["geometry"].present? ? feature["geometry"]["coordinates"] : nil,
	    																			circle_name: circle,
    																				ward_name: ward,
  																					asset_type: args[:asset_type])
    		asset.create_geometry feature["geometry"]
		  end
	  end
	  # FLUSH TEMPORARY FILE
  	flush_temporary_file(path)
	end

	task :urban_poverty, [:filename, :service_type, :asset_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	  	service_category = ServiceCategory.where(name: 'urban_poverty').first_or_create
	  	service = service_category.services.where(service_type: args[:service_type]).first_or_create
	  	metric = service.service_metrics.create(name: geojson["name"].downcase.tr(' ', '_'), crs: geojson["crs"])
	    geojson["features"].each do |feature|
	    	if service.service_type.eql?("public_toilets")
	    	asset = metric.service_assets.create(asset_id: feature["properties"].values[0],
	    																			 name: feature["properties"].values[1],
																			    	 circle_name: feature["properties"]["CIRCLE NO& NAME"].tr("-0-9-", ""),
    																				 ward_name: feature["properties"]["WARD NO&NAME"].tr("-0-9-", ""),
    																				 toilet_id: feature["properties"]["TOILLET_ID"],
    																				 properties: feature["properties"],
													 									 asset_type: args[:asset_type])
				elsif service.service_type.eql?("health")
					name = feature["properties"]["Hospital name"] || feature["properties"]["PHC Name"]
					asset = metric.service_assets.create(name: name,
																							 properties: feature["properties"].except("S.NO", "path", "layer"),
    																					 asset_type: args[:asset_type])
				elsif service.service_type.eql?("nutrition")
					circle = feature["properties"]["CIRCLE"]
		    	circle = circle.split('-').last if /\d?/.match(circle)
		    	ward = feature["properties"]["WARD"]
		    	ward = ward.split('-').last if /\d?/.match(ward)
		    	asset = metric.service_assets.create(properties: feature["properties"],
		    																			circle_name: circle,
	    																				ward_name: ward,
    																					asset_type: "rs_5_meal_canteen")
	    	else
	    		asset = metric.service_assets.create(properties: feature["properties"].except("S.NO", "path", "layer"),
    																					 asset_type: args[:asset_type])
	    	end
    		asset.create_geometry feature["geometry"]
		  end
	  end
	  # FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

	task :numpoints, [:filename, :numpoint_type, :level_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	    geojson["features"].each do |feature|
	    	if args[:level_type].eql?("Zone")
	    		level = Level.where(level_type: args[:level_type]).find_by(name: feature["properties"]["new_zones"])
	    	elsif args[:level_type].eql?("Circle")
	    		circle = feature["properties"]["CIR_NAME"]
	    		circle = circle.split('-').last if /\d?/.match(circle)
	    		level = Level.where(level_type: args[:level_type]).find_by(name: circle)
	    	elsif args[:level_type].eql?("Ward")
	    		ward = feature["properties"]["ward"]
	    		ward = ward.split('-').last if /\d?/.match(ward)
	    		level = Level.where(level_type: args[:level_type]).find_by(name: ward)
	    	end
	    		if level
	    			level.numpoint_distributions.create(numpoint_count: feature["properties"]["NUMPOINTS"],
	    																					numpoint_type: args[:numpoint_type])
	    		end
		  end
	  end
	  # FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

	task :grievances, [:filename, :grievance_type] => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	    geojson["features"].each do |feature|
	    	circle_name = feature["properties"]["CIRCLE_NAME"].split('-').last
	    	grievance = Grievance.create(grievance_type: args[:grievance_type],
	    															 ward_name: feature["properties"]["WARD_NAME"],
	    															 circle_name: circle_name,
	    															 status: feature["properties"]["STATUS"],
                                     location: feature["geometry"].present? ? feature["geometry"]["coordinates"] : nil,
	    															 sub_category: feature["properties"]["TYPE_NAME (SUB _ CATRGORY)"],
	    															 category: feature["properties"]["MAIN _CATEGORY"],
	    															 remark: feature["properties"]["REMARKS"])
	    	grievance.create_geometry feature["geometry"]
		  end
	  end
	  # FLUSH TEMPORARY FILE
	  flush_temporary_file(path)
	end

	# General Data
	task :general_data, [:filename, :public_resource_name, :resource_type]  => :environment do |t, args|
		file_path = File.join(Rails.root.join('geojson-files'), args[:filename])
		geojson = JSON.parse(File.open(file_path).read)
		basename = File.basename(file_path, File.extname(file_path))
	  if geojson.has_key? "features"
	    public_resource = PublicResource.where(name: args[:public_resource_name], crs: geojson["crs"]).first_or_create
	    geojson["features"].each do |feature|
		   	if args[:resource_type] == "outer_ring_road"
	    		resource = "Outer ring road"
        elsif feature["properties"]["Park_Name"].present?
          resource = feature["properties"]["Park_Name"]
        elsif args[:public_resource_name] == 'business'
          resource = feature["properties"]["name"]
    		else
			    resource = geojson["name"].downcase
	    	end
			  resource_detail = public_resource.resource_details.create(name: resource, resource_type: args[:resource_type],
			  			properties: feature['properties'])
				resource_detail.create_geometry(feature["geometry"])
			end
		end
		# FLUSH TEMPORARY FILE
	  # flush_temporary_file(path)
	end

	task :environment_data, [:filename, :category_name, :category]  => :environment do |t, args|
		path = fetch_file(args.filename)
		geojson = JSON.parse(File.open(path).read)
		basename = File.basename(path, File.extname(path))
	  if geojson.has_key? "features"
	    environment = Environment.where(name: args[:category_name], crs: geojson["crs"]).first_or_create
	    geojson["features"].each do |feature|
        name =  feature["properties"]["name"]
        properties = Hash.new
        feature['properties'].each do |key, value|
        	subbed_key = key.gsub('.', '')
        	properties[subbed_key] = value
        end
			  resource_detail = environment.environment_categories.create(name: name, category: args[:category],
			  			properties: properties)
				resource_detail.create_geometry(feature["geometry"])
			end
		end
		flush_temporary_file(path)
	end


end
