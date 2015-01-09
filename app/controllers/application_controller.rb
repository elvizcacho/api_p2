include ActionController::HttpAuthentication::Token::ControllerMethods
include ActionController::MimeResponds

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :null_session
  before_filter :set_locale

  private

  def restrict_access
  	unless (restric_access_by_params || restrict_access_by_header) && restrict_access_by_role
  		render json: {response: t('app.restrict_access.response')}, status: 401
  		return
  	end
  	@current_user = @api_key.user if @api_key
  end

  def restrict_access_by_header
  	return true if @api_key
    authenticate_with_http_token do |token|
  		@api_key = ApiKey.find_by_token(token)
  	end
  end

  def restric_access_by_params
  	return true if @api_key
  	@api_key = ApiKey.find_by_token(params[:token])
  end

  def restrict_access_by_role
    actions = ApiKey.find_by_token(params[:token]).user.role.controller_actions
    controller = params[:controller].scan(/v\d\.{0,1}\d*\/([^\/]+)$/)[0][0]
    for action in actions
      controller_name = ControllerAction.find(action.controller_action_id).name
      if action.name == params[:action] && controller_name == controller
        return true
      end
    end
    return false
  end

  protected

  def get_range_header
    range = request.headers['Range']
    range = range.scan(/\w+\s*=\s*(\w+)\s*-\s*(\w+)/)
    return range[0][0].to_i, range[0][1].to_i
  end

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
    elsif extract_locale_from_accept_language_header == 'es'
      I18n.locale = 'es'
    elsif extract_locale_from_accept_language_header == 'en'
      I18n.locale = 'en'
    else
      I18n.locale = I18n.default_locale
    end
  end

  private

  def extract_locale_from_accept_language_header
    request.headers['Accept-Language'].nil? ? 'en' : request.headers['Accept-Language'].scan(/^[a-z]{2}/).first
  end

end
