module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access, :except => [:login]

     	    ##
          # Returns an array of Users. 
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
          #         "role_id": 1,
          #         "name": "Sebastian",
          #         "email": "admin@gmail.com",
          #         "created_at": "2015-01-02T21:07:54.517Z",
          #         "updated_at": "2015-01-02T21:07:54.517Z"
          #      }, {
          #         "id": 2,
          #         "role_id": 2,
          #         "name": "Laura",
          #         "email": "laura@gmail.com",
          #         "created_at": "2015-01-02T21:07:54.837Z",
          #         "updated_at": "2015-01-02T21:07:54.837Z"
          #      }]
        
          def index
            if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = User.select(:id, :role_id, :name, :email, :created_at, :updated_at).limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: t('users.index.response')}, status: 416 
            end
    	    end

          ##
          # Creates an User.
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
          # Deletes an User.
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
            response, status = User.destroy_from_model(:id => params[:id], :token => params[:token], :controller => params[:controller], :action => params[:action])
            render :json => response, :status => status
          end

          ##
          # Updates an User.
          # 
          # PUT or PATCH /api/v1/users/:id
          #
          # params:
          #   id - number       [Required]
          #   name - string     
          #   role_id - number  
          #   token - API token [Required]
          #   email - string
          #   
          # = Examples
          #   
          #   resp = conn.put("/api/v1/users/4", "name" => "Ana", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #         "response": "User 4 was updated"
          #      }

          def update
            response, status = User.update_from_model(:id => params[:id], :token => params[:token], :name => params[:name], :role_id => params[:role_id], :email => params[:email], :controller => params[:controller], :action => params[:action])
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
          #         "id": 1,
          #         "role_id": 1,
          #         "token": "c56ef37ffc50aa334cc5314a1d3c162a"
          #      }

          def login
            user = User.where(password: Digest::MD5.hexdigest(params[:password]), email: params[:email]).first
            if user
              render json: {id: "#{user.id}", role_id: "#{user.role_id}",token: "#{user.api_key.token}"}, status: 200
            else
              render json: {response: t('users.login.response')}, status: 401
            end
          end

          ##
          # Shows an User.
          #
          # Show
          # 
          # GET /api/v1/users/:id
          #
          # params:
          #   id - number       [Required]
          #   token - API token [Required]
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
          #        "role_id": 1,
          #        "name": "Sebastian",
          #        "email": "admin@gmail.com",
          #        "created_at": "2015-01-02T21:07:54.517Z",
          #        "updated_at": "2015-01-02T21:07:54.517Z"
          #      }

          def show
            begin
              user = User.select(:id, :role_id, :name, :email, :created_at, :updated_at).find(params[:id])
              render json: ActiveSupport::JSON.encode(user), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
          end

          ##
          # Gets User role.
          #
          # Role
          # 
          # GET /api/v1/users/:id/role
          #
          # params:
          #   id - number       [Required]
          #   token - API token [Required]
          #      
          # = Examples
          #   
          #   resp = conn.get("/api/v1/users/1/role", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #        "id": 1,
          #        "name": "admin",
          #        "created_at": "2015-01-02T21:07:54.465Z",
          #        "updated_at": "2015-01-02T21:07:54.465Z"
          #      }

          def role
            begin
              role = User.find(params[:id]).role
              render json: ActiveSupport::JSON.encode(role), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
          end

          ##
          # Updates User password.
          #
          # update_password
          # 
          # PUT/PATCH /api/v1/users/:id/update_password
          #
          # params:
          #   id - number       [Required]
          #   current_password - string
          #   new_password - string
          #   token - API token [Required]
          #      
          # = Examples
          #   
          #   resp = conn.put("/api/v1/users/1/update_password", "id" => 1, "current_password" => "1234", "new_password" => "hola", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
          #   
          #   resp.status
          #   => 200 - OK
          #
          #   resp.body
          #   => {
          #        "response": "User password was updated"
          #      }

          def update_password
            response, status = User.update_password(:id => params[:id], :current_password => params[:current_password], :new_password => params[:new_password], :token => params[:token], :controller => params[:controller], :action => params[:action])
            render :json => response, :status => status
          end

      end
    end
end