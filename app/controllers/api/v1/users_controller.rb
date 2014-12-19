module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access, :except => [:index]

     	    ##
          # This is an API test
          #
          # GET /api/v1/users
          #
          # params:
          #   token - API token
          #
          # = Examples
          #
          #   resp = conn.get("/api/v1/users", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #
          #   resp.status
          #   => 404
          #
          #   resp.body
          #   => {"message": "Resource not found"}
        
          def index
            hola = User.all.to_a
      	    render json: ActiveSupport::JSON.encode(hola)
    	    end

          def create
            User.create(:name => params[:name])
            render json: {response: 'User was created', user_id: User.last.id}
          end

    	

        end
    end
end