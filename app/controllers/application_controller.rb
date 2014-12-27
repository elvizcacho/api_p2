include ActionController::HttpAuthentication::Token::ControllerMethods
include ActionController::MimeResponds

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :null_session

  private

  def restrict_access
  	unless (restric_access_by_params || restrict_access_by_header) && restrict_access_by_role
  		render json: {message: 'Invalid API Token'}, status: 401
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
    controller_actions = ApiKey.find_by_token(params[:token]).user.role.controller_actions
    controller = params[:controller].scan(/v\d\.{0,1}\d*\/([^\/]+)$/)[0][0]
    for ca in controller_actions
      if ca.controller_actions.length > 0
        controller_name = ca.name
        for action in ca.controller_actions
          if action.name == params[:action] && controller_name == controller
            return true
          end
        end
      else
        controller_name = ControllerAction.find(ca.controller_action_id).name
        if ca.name == params[:action] && controller_name == controller
          return true
        end
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

end
