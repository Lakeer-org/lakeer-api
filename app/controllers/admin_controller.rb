class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, except: :restricted_access

  def restricted_access
  end
end
