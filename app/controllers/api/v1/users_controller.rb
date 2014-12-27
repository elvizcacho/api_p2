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
            if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = User.limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: 'No rage header defined'}, status: 416 
            end
    	    end

          def create
            User.create(:name => params[:name])
            render json: {response: 'User was created', user_id: User.last.id}
          end

          def destroy
            begin
              user = ApiKey.find_by_token(params[:token]).user
              role = user.role.id
              if role == 1
                User.find(params[:id]).destroy  
                render json: {response: "User #{params[:id]} was deleted"}
              elsif role == 2 && user.id == params[:id].to_i
                User.find(params[:id]).destroy  
                render json: {response: "User #{params[:id]} was deleted"}
              else
                render json: {response: "Only Admin or the owner account can request this action"}
              end
            rescue Exception => e
              render json: {response: "#{e}"}
            end
          end

    	

        end
    end
end