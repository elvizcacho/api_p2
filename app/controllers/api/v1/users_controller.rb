module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access, :except => [:login]

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
          #         "id": 1,
          #         "name": "Sebastian",
          #         "created_at": "2015-01-02T20:44:15.661Z",
          #         "updated_at": "2015-01-02T20:44:15.661Z",
          #         "role_id": 1,
          #         "email": "admin@gmail.com",
          #         "password": "81dc9bdb52d04dc20036dbd8313ed055"
          #       }, {
          #          "id": 2,
          #          "name": "Laura",
          #          "created_at": "2015-01-02T20:44:15.957Z",
          #          "updated_at": "2015-01-02T20:44:15.957Z",
          #          "role_id": 2,
          #          "email": "laura@gmail.com",
          #          "password": "81dc9bdb52d04dc20036dbd8313ed055"
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
          #   email - string    [Required]
          #   password - string [Required]
          #
          # = Examples
          #   
          #   resp = conn.post("/api/v1/users", "name" => "Sebastian", "role_id" => 2, "email" => "email@domain.com", "password" => "1234", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
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
            response, status = User.create_from_model(:name => params[:name], :role_id => params[:role_id], :password => params[:password], :email => params[:email])
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
          #   resp = conn.delete("/api/v1/users/4", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
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
          #   email - string
          #   password - string
          #   
          # = Examples
          #   
          #   resp = conn.put("/api/v1/users/4", "name" => Ana, "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #         "response": "User 4 was updated"
          #      }

          def update
            response, status = User.update_from_model(:id => params[:id], :token => params[:token], :name => params[:name], :role_id => params[:role_id], :password => params[:password], :email => params[:email])
            render :json => response, :status => status
          end

          ##
          # Login
          # 
          # POST /api/v1/users/login
          #
          # params:
          #   email - string    [Required]
          #   password - string [Required]
          #   
          # = Examples
          #   
          #   resp = conn.post("/api/v1/users/login", "email" => "sebastian@gmail.com", "password" => "1234")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #         "token": "c56ef37ffc50aa334cc5314a1d3c162a"
          #      }

          def login
            user = User.where(password: Digest::MD5.hexdigest(params[:password]), email: params[:email]).first
            if user
              render json: {token: "#{user.api_key.token}"}, status: 200
            else
              render json: {response: "Invalid email or password"}, status: 401
            end
          end

          ##
          # Show
          # 
          # GET /api/v1/users/:id
          #
          # params:
          #   id - number    [Required]
          #      
          # = Examples
          #   
          #   resp = conn.get("/api/v1/users/1", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #        "id": 1,
          #        "name": "Sebastian",
          #        "created_at": "2015-01-02T20:44:15.661Z",
          #        "updated_at": "2015-01-02T20:44:15.661Z",
          #        "role_id": 1,
          #        "email": "admin@gmail.com",
          #        "password": "81dc9bdb52d04dc20036dbd8313ed055"
          #      }

          def show
            begin
              user = User.find(params[:id])
              render json: ActiveSupport::JSON.encode(user), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
          end

        end
    end
end