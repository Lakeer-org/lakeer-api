module Facets
  extend ActiveSupport::Concern

  def get_facets(total_count)
    per_page = 20
    @facets = OpenStruct.new # initializing OpenStruct instance
    @facets.total_count = total_count
    @facets.filtered_count = @object_without_pagination.length
    @facets.total_pages = (@object_without_pagination.length/per_page.to_f).ceil
    if !params.has_key?(:page)
      params[:page] = 1
    end
    @facets.current_page = params[:page].to_i
    # Previous Page
    if @facets.current_page - 1 == 0
      @facets.previous_page = false
    else
      @facets.previous_page = true
    end
    # Next Page
    if @facets.current_page + 1 > @facets.total_pages
      @facets.next_page = false
    else
      @facets.next_page = true
    end
  end
end
