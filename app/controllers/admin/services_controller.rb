class Admin::ServicesController < AdminController
	before_action :set_service, only: [:edit, :update, :show]

	def index
		@services = @service_category.services.order(position: :asc)
	end

	def new
		@service_categories = ServiceCategory.all
		@service = Service.new
	end

	def edit
		@service_categories = ServiceCategory.all
	end

	def show
    @service_metrics = @service.service_metrics.order(position: :asc)
	end

	def create
		@service = Service.new(service_params)
 		respond_to do |format|
      if @service.save
        format.html { redirect_to admin_service_category_path(@service.service_category), notice: 'Service was updated.' }
        format.json { render :show, status: :ok, location: admin_service_path(@service) }
      else
        format.html { render :edit }
        format.json { render json: admin_service_category_service_path(@service_category, @service).errors, status: :unprocessable_entity }
      end
    end
  end

 	def update
 		respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to admin_service_category_path(@service.service_category), notice: 'Service was updated.' }
        format.json { render :show, status: :ok, location: admin_service_path(@service) }
      else
				@service_categories = ServiceCategory.all
        format.html { render :edit }
        format.json { render json: admin_service_category_service_path(@service_category, @service).errors, status: :unprocessable_entity }
      end
    end
  end

	private


	def set_service
		@service = Service.find(params[:id])
	end

	def service_params
    params.require(:service).permit(:name, :position, :is_visible, :service_category_id, :service_type)
  end
end
