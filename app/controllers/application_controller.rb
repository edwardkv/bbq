class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?

  def configure_permitted_parameters

    devise_parameter_sanitizer.permit(:account_update,
                                       keys: [:password, :password_confirmation, :current_password, :name])

    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def current_user_can_edit?(model)
    # If the model has a user and he is logged in, try to take .event from her
    # If there is one, check its user for equality current_user.
    user_signed_in? && (
      model.user == current_user ||
        (model.try(:event).present? && model.event.user == current_user)
    )
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
      parsed_locale.to_sym : nil
  end
end