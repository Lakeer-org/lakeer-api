module ApplicationHelper
  def pagination_keys(click_class, facets)
		raw("<nav aria-label='Page navigation example'>
          <ul class='pagination justify-content-center'>
            <li class='page-item #{facets.previous_page != false ? "" : "hidden"} cursor-pointer'>
      				<a class='page-link' id='#{click_class}_pagination_previous_page'  aria-label='Previous'>
      					<span aria-hidden='true'>Previous</span></a>
      			</li>
            <li class='page-item'>
      				<a id='#{click_class}_current_page'  data-page='#{@facets.current_page}' class='page-link'>
                Showing #{facets.current_page} of #{facets.total_pages} pages
              </a>
      			</li>
            <li class='page-item #{facets.next_page != false ? "" : "hidden"} cursor-pointer'>
      				<a class='page-link' id='#{click_class}_pagination_next_page'  aria-label='Next'>
      					<span aria-hidden='true'>Next</span></a>
      			</li>
          </ul>
        </nav>")
	end

  def checked(object)
    raw("<div class='fa #{object == true ? 'fa-check' : 'fa-times'}'></div>")
  end
end
