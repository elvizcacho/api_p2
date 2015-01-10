module Api
    module V1
      class RolesController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # It returns an array of Roles. 
        # The number of roles that is returned depends on the Range Header parameter.
        #
        # GET /api/v1/roles
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   range - items=num-num
        # = Examples
        #   range: items=0-1
        #   resp = conn.get("/api/v1/roles", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   =>   [{
    	#		"id": 1,
    	#		"name": "admin",
    	#		"created_at": "2015-01-02T21:07:54.465Z",
    	#		"updated_at": "2015-01-02T21:07:54.465Z"
		#	   }, {
    	#		"id": 2,
    	#		"name": "client",
    	#		"created_at": "2015-01-02T21:07:54.833Z",
    	#		"updated_at": "2015-01-02T21:07:54.833Z"
		#	   }]
		#

      	def index
      		if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = Role.limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: t('roles.index.response')}, status: 416 
           	end	
      	end

    	##
    	# It shows a Role.
    	#
        # Show
        # 
        # GET /api/v1/roles/:id
        #
        # params:
        #   id - number    [Required]
        #      
        # = Examples
        #   
        #   resp = conn.get("/api/v1/roles/2", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   =>   {
    	#		 "id": 2,
    	#		 "name": "client",
    	#		 "created_at": "2015-01-02T21:07:54.833Z",
    	#		 "updated_at": "2015-01-02T21:07:54.833Z"
		#	   }

      	def show
            begin
              user = Role.find(params[:id])
              render json: ActiveSupport::JSON.encode(user), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
        end

        ##
        # It creates a new Role.
        # 
        # POST /api/v1/roles
        #
        # params:
        #   name - string     [Required]
        #
        # = Examples
        #   
        #   resp = conn.post("/api/v1/roles", "name" => "guest", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 201 - Created
        #
        #   resp.body
        #   => {
        #         "response": "Role was created",
        #         "role_id": 3
        #      }

        def create
          	response, status = Role.create_from_model(:name => params[:name])
          	render :json => response, :status => status
        end

        ##
        # It deletes a Role.
        # 
        # DELETE /api/v1/roles/:id
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required] 
        #   
        # = Examples
        #   
        #   resp = conn.delete("/api/v1/roles/3", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Role 3 was deleted"
        #      }

        def destroy
            response, status = Role.destroy_from_model(:id => params[:id], :token => params[:token])
            render :json => response, :status => status
        end

        ##
        # It updates a Role.
        # 
        # PUT or PATCH /api/v1/roles/:id
        #
        # params:
        #   id - number       [Required]
        #   name - string     
        #   token - API token [Required]
        #   
        # = Examples
        #   
        #   resp = conn.put("/api/v1/roles/3", "name" => "member", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Role 3 was updated"
        #      }

        def update
            response, status = Role.update_from_model(:id => params[:id], :token => params[:token], :name => params[:name])
            render :json => response, :status => status
        end

        ##
        # Gets Role permissions.
        #
        # It returns an array of all id actions and permissions into them.
        #
        # GET /api/v1/roles/:id/permissions
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required]
        #   
        # = Examples
        #   
        #   resp = conn.get("/api/v1/roles/2/permissions", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => [4, 5, 18, 19, 15]

        def show_permissions
            response, status = Role.get_permissions(:id => params[:id])
            render :json => response, :status => status
        end

        ##
        # Sets Role permissions.
        #
        # It sets role permissions.
        #
        # POST /api/v1/roles/:id/permissions
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required]
        #   permissions - integer array - see example
        #   
        # = Examples
        #   
        #   resp = conn.post("/api/v1/roles/2/permissions", "permissions" => [2, 3, 4, 5],"token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Role permissions were assigned"
        #      }

        def assign_permissions
            response, status = Role.set_permissions(:id => params[:id], :permissions => params[:permissions])
            render :json => response, :status => status
        end

      end
  end
end