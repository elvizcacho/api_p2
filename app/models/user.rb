class User < ActiveRecord::Base
	
	has_one :api_key, dependent: :destroy
	belongs_to :role
    after_create :create_api_key
    validates :name, presence: true, length: {minimum: 3}
    validates :role_id, presence: true

    def create_api_key
    	ApiKey.create :user => self
    end
    
end
