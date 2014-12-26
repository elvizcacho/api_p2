class Role < ActiveRecord::Base
	has_and_belongs_to_many :controller_actions
	has_many :users
end