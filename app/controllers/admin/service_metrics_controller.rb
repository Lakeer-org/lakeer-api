class Admin::ServiceMetricsController < AdminController
	before_action :set_service_metric, only: [:edit, :update, :show]

	def index
		@service_metrics = ServiceMetric.all.order(position: :asc)
		respond_to do |format|
      format.html
      format.csv { send_data @service_metrics.to_csv, filename: "service_metrics-#{Date.today}.csv" }
    end
	end

	def edit
		@services = Service.all
	end

	def show
	end

 	def update
 		respond_to do |format|
      if @service_metric.update!(service_metric_params)
        format.html { redirect_to admin_service_path(@service_metric.service), notice: 'Metric was updated.' }
        format.json { render :show, status: :ok, location: admin_service_metric_path(@service_metric) }
      else
        format.html { render :edit }
        format.json { render json: admin_service_metric_path(@service_metric).errors, status: :unprocessable_entity }
      end
    end
  end

	private

	def set_service_metric
		@service_metric = ServiceMetric.find(params[:id])
	end

	def service_metric_params
    params.require(:service_metric).permit(:display_name, :description, :data_source, :data_verification, :vintage, :position, :is_visible, :service_id)
  end
end
