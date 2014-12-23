module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access, :except => [:create]

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
              range = request.headers['Range']
              range = range.scan(/\w+\s*=\s*(\w+)\s*-\s*(\w+)/)
              from = range[0][0].to_i
              to = range[0][1].to_i
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
              User.find(params[:id]).destroy  
              render json: {response: "User #{params[:id]} was deleted"}
            rescue Exception => e
              render json: {response: "#{e}"}
            end
          end

    	

        end
    end
end