require 'fileutils'
module S3FileFetch

	def fetch_file(filename)
		generate_aws_config unless Aws.config.present?
		# HARDCODING BUCKET REGION
		s3 = Aws::S3::Resource.new(region: 'us-east-1')
		obj = s3.bucket('lakeer-geojson').object(filename)
		file = "/tmp/#{filename}"
		obj.get(response_target: file)
		return file
	end

	def generate_aws_config
		aws = Rails.application.credentials[:aws]
		Aws.config.update({ 
			credentials: Aws::Credentials.new(aws[:access_key_id], aws[:secret_access_key])
		})
	end

	def flush_temporary_file(path)
		FileUtils.rm(path)
	end
end


