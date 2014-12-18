class User < ActiveRecord::Base
	
	has_one :api_key, dependent: :destroy
    after_create :create_api_key

     def create_api_key
    	ApiKey.create :user => self
    end
end
