class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'ext/string'
  protect_from_forgery with: :exception
  include SessionsHelper
  before_filter	:set_tenant
  after_filter :check_tenant

  def set_tenant
    @tenant = Tenant.current = Tenant.where(:host => (request.subdomain.nil? ? "" : request.subdomain) ).first
    logger.debug(@tenant)
    # TODO tenant not found

  end

  def check_tenant
    if (@tenant.host == "www" && controller_name != 'static_pages' && action_name != 'home')
      redirect_to  :controller=>'static_pages', :action => 'home'
    end
  end

  # allow_cors takes in arbitrarily many symbols representing actions that
  # CORS should be enabled for
  def self.allow_cors(*methods)
    before_filter :cors_before_filter, :only => methods
    # Rails recommends to use :null_session for APIs
    protect_from_forgery with: :null_session, :only => methods
  end

  def cors_before_filter
    # Check that the `Origin` field matches our front-end client host
    if /\Ahttps?:\/\/localhost:8085\z/ =~ request.headers['Origin']
      headers['Access-Control-Allow-Origin'] = request.headers['Origin']
    end
  end

end
