require 'csv'
require 'open-uri'
namespace :import do
  task :service_metric_detail => :environment do

    constant_file_name = 'lib/imports/service_metrics-2019-01-25.csv'
    puts constant_file_name
    counter = 0
    CSV.foreach(constant_file_name, headers: true) do |row|
      service_metric = ServiceMetric.where(name: row["name"]).first
      if service_metric.present?
        puts "++ServiveMetric is present and updating+++"
        service_metric.update!(display_name: row['display_name'],
          description: row['description'], data_source: row['data_source'],
          data_verification: row['data_verification'], vintage: row['vintage'],
          position: row['position'])
      else
        puts "--ServiveMetric is not present------> #{row['name']}"
      end
    end
  end
end
