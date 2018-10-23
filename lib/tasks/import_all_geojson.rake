namespace :import do
  desc "Place the geojson files in project root and run the task"
  task :all_rake do
    # rails import_geojsons:basic_services["Hyderabad_MMTS_stops.geojson","public_transport","mmts_stop"]
    Rake::Task["import_geojsons:basic_services"].invoke("Hyderabad_MMTS_stops.geojson","public_transport","mmts_stop")
  end
end
