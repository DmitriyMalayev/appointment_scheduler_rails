# Handling OAuth Callback Request
# This needs to match exactly what we have in our routes
# Because this controller is in a folder called users it has to be namespaced.
# It also has to inherit from Devise::OmniAuthCallbacksController this will allow us to only be affecting the part that we want to and everything else will be left intact.

class Users::OmniAuthCallbacksController < Devise::ApplicationController
  user = User.from_google(from_google_params) #This controller action will get hit with the final redirect from google back to our site including the user info. 

  if user.present?
    sign_out_all_scopes
    flash[:success] = t "devise.omniauth_callbacks.success", kind: "Google"
    sign_in_and_redirect user, event: :authentication
  else
    flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized."
    redirect_to new_user_session_path
  end
end

protected

def after_omniauth_failure_path_for(_scope) 
    new_user_session_path
end 

def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path 
end 

private 

def from_google_params
    @from_googleparams ||= {
        uid: auth.uid,
        email: auth.info.email,
        full_name: auth.info.name,
        avatar_url: auth.info.image 

    }
end 














