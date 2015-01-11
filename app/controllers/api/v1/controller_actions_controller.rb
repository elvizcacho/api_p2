module Api
    module V1
      class ControllerActionsController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # It returns an object with all controllers and actions. 
        # 
        #
        # GET /api/v1/controller_actions
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   
        # = Examples
        #   resp = conn.get("/api/v1/controller_actions", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
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
        #                                    "name": "index",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 3,
        #                                    "name": "create",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 4,
        #                                    "name": "destroy",
        #                                    "controller_actions": [{
        #                                                            "id": 24,
        #                                                            "name": "destroy other users"
        #                                                        }, {
        #                                                            "id": 25,
        #                                                            "name": "destroy itself"
        #                                                            }]
        #                                    }, {
        #                                    "id": 5,
        #                                    "name": "update",
        #                                    "controller_actions": [{
        #                                                            "id": 18,
        #                                                            "name": "update role_id"
        #                                                        }, {
        #                                                            "id": 19,
        #                                                            "name": "update password"
        #                                                        }, {
        #                                                            "id": 20,
        #                                                            "name": "update other users"
        #                                                        }, {
        #                                                            "id": 21,
        #                                                            "name": "update itself"
        #                                                            }]
        #                                    }, {
        #                                    "id": 6,
        #                                    "name": "login",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 7,
        #                                    "name": "show",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 14,
        #                                    "name": "role",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 15,
        #                                    "name": "update_password",
        #                                    "controller_actions": [{
        #                                                            "id": 26,
        #                                                            "name": "update other users password"
        #                                                            }, {
        #                                                            "id": 27,
        #                                                            "name": "update own user password"
        #                                                            }]
        #                                    }]
        #        }, {
        #            "id": 8,
        #            "name": "roles",
        #            "controller_actions": [{
        #                                    "id": 9,
        #                                    "name": "index",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 10,
        #                                    "name": "show",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 11,
        #                                    "name": "create",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 12,
        #                                    "name": "destroy",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 13,
        #                                    "name": "update",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 22,
        #                                    "name": "show_permissions",
        #                                    "controller_actions": []
        #                                    }, {
        #                                    "id": 23,
        #                                    "name": "assign_permissions",
        #                                    "controller_actions": []
        #                                    }]
        #        }]
        #

      	def index
      		controllers = ControllerAction.select(:id, :name).where(:controller_action_id => nil)
            render json: controllers.as_json(
                include: { controller_actions: {
                           include: { controller_actions: {
                                          only: [:id, :name] 
                                      } 
                                    },
                           only: [:id, :name] 
                           } 
                        }
            )
        end

      end
  end
end