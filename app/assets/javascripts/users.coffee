current_request = null
admin_get_user = (page) ->
  search_term = $('.user_search').val()
  if typeof page == undefined
    page = 1
  current_request = $.ajax '/admin/users',
    type: 'GET'
    data: {
      template: false,
      search_term: search_term,
      page: page,
    }
    beforeSend: ->
      if current_request != null
        current_request.abort()
      return     
    success: (data, jqxhr, textStatus) ->
      $('#user-table-section').html data
    error:(jqxhr, textStatus, errorThrown) ->
      console.log "Something Wrong with Filters"      

$(document).on 'keyup', '.user_search', () ->
  $ -> admin_get_user()

$(document).on 'click', '#user_pagination_next_page', ()->
  current_page = parseInt $('#user_current_page').data('page')
  $ -> admin_get_user(current_page+1)

$(document).on 'click', '#user_pagination_previous_page', ()->
  current_page = parseInt $('#user_current_page').data('page')
  $ -> admin_get_user(current_page-1)
