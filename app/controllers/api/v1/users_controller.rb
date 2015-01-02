module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access, :except => []

     	    ##
          # It returns an array of Users. 
          # The number of users that is returned depends on the Range Header parameter.
          #
          # GET /api/v1/users
          #
          # params:
          #   token - API token [Required]
          # 
          # header:
          #   range - items=num-num
          # = Examples
          #   range: items=0-1
          #   resp = conn.get("/api/v1/users", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 206 - Partial Content
          #
          #   resp.body
          #   => [{
          #         "id": 4,
          #         "name": "Sebas",
          #         "created_at": "2014-12-18T15:29:17.738Z",
          #         "updated_at": "2014-12-18T15:29:17.738Z",
          #         "role_id": 2
          #       }, {
          #         "id": 5,
          #         "name": "Luis Alvarez",
          #         "created_at": "2014-12-19T15:06:31.038Z",
          #         "updated_at": "2014-12-19T15:06:31.038Z",
          #         "role_id": 2
          #       }]
        
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

          ##
          # It creates an User. 
          # 
          # POST /api/v1/users
          #
          # params:
          #   name - string     [Required]
          #   role_id - number  [Required]
          #   token - API token [Required]
          # 
          #   
          # = Examples
          #   
          #   resp = conn.get("/api/v1/users", "name" => "Sebastian", "role_id" => 2, token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 201 - Created
          #
          #   resp.body
          #   => {
          #         "response": "User was created",
          #         "user_id": 9
          #      }

          def create
            response, status = User.create_from_model(:name => params[:name], :role_id => params[:role_id])
            render :json => response, :status => status
          end

          ##
          # It deletes an User.
          # 
          # DELETE /api/v1/users/:id
          #
          # params:
          #   id - number       [Required]
          #   token - API token [Required] 
          #   
          # = Examples
          #   
          #   resp = conn.get("/api/v1/users/4", token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #         "response": "User 4 was deleted"
          #      }

          def destroy
            response, status = User.destroy_from_model(:id => params[:id], :token => params[:token])
            render :json => response, :status => status
          end

          ##
          # It updates an User.
          # 
          # PUT or PATCH /api/v1/users/:id
          #
          # params:
          #   id - number       [Required]
          #   name - string     
          #   role_id - number  
          #   token - API token [Required] 
          #   
          # = Examples
          #   
          #   resp = conn.get("/api/v1/users/4", token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #         "response": "User 4 was updated"
          #      }

          def update
            response, status = User.update_from_model(:id => params[:id], :token => params[:token], :name => params[:name], :role_id => params[:role_id])
            render :json => response, :status => status
          end

        end
    end
end