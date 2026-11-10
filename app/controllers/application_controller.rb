class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  include Rails.application.routes.url_helpers
  include AdminAccess
end
