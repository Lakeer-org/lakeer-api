class Admin::ServiceCategoriesController < AdminController
	before_action :set_service_category, only: [:edit, :update, :show]

	def index
		@service_categories = ServiceCategory.all.order(position: :asc)
	end

	def new
		@service_category = ServiceCategory.new
	end

	def edit
	end

	def show
		@services = @service_category.services
	end

	def create
		@service_category = ServiceCategory.new(service_category_params)
		respond_to do |format|
      if @service_category.save
        format.html { redirect_to admin_service_categories_path, notice: 'Category saved successfully!.' }
        format.json { render :show, status: :ok, location: admin_service_categories_path }
      else
        format.html { render :edit }
        format.json { render json: admin_service_category_path(@service_category).errors, status: :unprocessable_entity }
      end
    end
	end

 	def update
 		respond_to do |format|
      if @service_category.update!(service_category_params)
        format.html { redirect_to admin_service_categories_path, notice: 'Category was updated.' }
        format.json { render :show, status: :ok, location: admin_service_categories_path }
      else
        format.html { render :edit }
        format.json { render json: admin_service_category_path(@service_category).errors, status: :unprocessable_entity }
      end
    end
  end

	private

	def set_service_category
		@service_category = ServiceCategory.find(params[:id])
	end

	def service_category_params
    params.require(:service_category).permit(:name, :position, :is_visible)
  end
end
