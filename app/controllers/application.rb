# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :render_to_string
  helper_attr :current_user
  protect_from_forgery :secret => 'd9822682e4611897d93129f57a77258d'
  ensure_authenticated_to_facebook

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  attr_accessor :current_user
  before_filter :set_current_user
  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def set_current_user
    if facebook_session and
            facebook_session.secured? and
            !request_is_facebook_tab?
      self.current_user =
              User.for(facebook_session.user.id, facebook_session)
      end
    end
  end
