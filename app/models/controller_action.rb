class ControllerAction < ActiveRecord::Base
	has_many :controller_actions
	has_and_belongs_to_many :roles
end
