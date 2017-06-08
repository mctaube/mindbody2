class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:mindbody_id])

    devise_parameter_sanitizer.permit(:account_update, :keys => [:mindbody_id])
  end


  protect_from_forgery with: :exception
  before_action :authenticate_user!

end
