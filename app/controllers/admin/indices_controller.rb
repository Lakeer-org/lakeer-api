class Admin::IndicesController < AdminController
	before_action :set_index, only: [:edit, :update, :show, :destroy]

	def index
		@indices = Index.all
	end

	def edit
	end

	def show
	end

	def update
		respond_to do |format|
			if @index.update!(index_params)
	      format.html { redirect_to admin_index_path(@index), notice: 'Index was updated.' }
	      format.json { render :show, status: :ok, location: admin_index_path(@index) }
	    else
	      format.html { render :edit }
	      format.json { render json: admin_index_path(@index).errors, status: :unprocessable_entity }
	  	end
		end
	end

	# DELETE /indices/1
  # DELETE /indices/1.json
  def destroy
    @index.destroy
    respond_to do |format|
      format.html { redirect_to admin_indices_url, notice: 'Index was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


	private

	def set_index
		@index = Index.find(params[:id])
	end

	def index_params
		params.require(:index).permit(:name, :is_recommended)
	end
end
