class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found   
  
  def not_found
    flash[:error] = "Not found"
    redirect_to root_path  
  end 
  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number])
  end
end

# Private methods: are methods defined under the private keyword/method. Private methods can only be used within the class definition; they’re for internal usage. The only way to have external access to a private method is to call it within a public method. Also, private methods can not be called with an explicit receiver, the receiver is always implicitly self. Think of private methods as internal helper methods.

# Protected methods: a protected method is similar to a private method, with the addition that it can be called with, or without, an explicit receiver, but that receiver is always self (it’s defining class) or an object that inherits from self (ex: is_a?(self)). 