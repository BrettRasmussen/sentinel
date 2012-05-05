class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    def ensure_admin
      if !current_user.is_admin?
        flash[:error] = 'You are not authorized to do that.'
        redirect_to root_url
        return false
      end
      true
    end
end
