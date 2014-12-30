module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access, :except => [:index]

     	    ##
          # It returns an array of Users. 
          # The number of users that is returned depends on the Range Header parameter.
          #
          # GET /api/v1/users
          #
          # params:
          #   token - API token
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
          #   name - username   [Required]
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
            User.create(:name => params[:name], :role_id => params[:role_id])
            render json: {response: 'User was created', user_id: User.last.id}, status: 201
          end

          ##
          # It deletes an User.
          # 
          # DELETE /api/v1/users
          #
          # params:
          #   id - username     [Required]
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
            begin
              user = ApiKey.find_by_token(params[:token]).user
              role = user.role.id
              if role == 1
                User.find(params[:id]).destroy  
                render json: {response: "User #{params[:id]} was deleted"}, status: 200
              elsif role == 2 && user.id == params[:id].to_i
                User.find(params[:id]).destroy  
                render json: {response: "User #{params[:id]} was deleted"}, status: 200
              else
                render json: {response: "Only Admin or the owner account can request this action"}, status: 401
              end
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
          end

    	

        end
    end
end