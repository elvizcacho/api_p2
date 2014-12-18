module Api
    module V1
      class UsersController < ApplicationController

      	before_filter :restrict_access 


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
      	  render json: {message: 'Resource not found'}, status: 404
    	end

    	

      end
    end
  end