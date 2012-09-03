class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl
  include SessionsHelper
end
