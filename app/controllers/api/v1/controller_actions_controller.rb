module Api
    module V1
      class ControllerActionsController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # It returns an object with all controllers and actions. 
        # 
        #
        # GET /api/v1/roles
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   
        # = Examples
        #   resp = conn.get("/api/v1/roles", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   =>   [{
        #            "id": 1,
        #            "name": "users",
        #            "controller_actions": [{
        #                                    "id": 2,
        #                                    "name": "index"
        #                                    }, {
        #                                    "id": 3,
        #                                    "name": "create"
        #                                    }, {
        #                                    "id": 4,
        #                                    "name": "destroy"
        #                                    }, {
        #                                    "id": 5,
        #                                    "name": "update"
        #                                    }, {
        #                                    "id": 6,
        #                                    "name": "login" 
        #                                    }, {
        #                                    "id": 7,
        #                                    "name": "show"
        #                                    }, {
        #                                    "id": 14,
        #                                    "name": "role"
        #                                    }, {
        #                                    "id": 15,
        #                                    "name": "update_password"
        #                                   }]
        #        }, {
        #            "id": 8,
        #            "name": "roles",
        #            "controller_actions": [{
        #                                    "id": 9,
        #                                    "name": "index"
        #                                }, {
        #                                    "id": 10,
        #                                    "name": "show"
        #                                }, {
        #                                    "id": 11,
        #                                    "name": "create"
        #                                }, {
        #                                    "id": 12,
        #                                    "name": "destroy"
        #                                }, {
        #                                    "id": 13,
        #                                    "name": "update"
        #                                }]
        #        }]
		#

      	def index
      		controllers = ControllerAction.select(:id, :name).where(:controller_action_id => nil)
            render json: controllers.as_json(include: {controller_actions: {only: [:id, :name]}} ), status: 200
        end

      end
  end
end