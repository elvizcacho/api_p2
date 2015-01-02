class User < ActiveRecord::Base
	
	has_one :api_key, dependent: :destroy
	belongs_to :role
    after_create :create_api_key
    before_create :password_to_md5_on_create
    before_update :password_to_md5_on_update
    validates :name, presence: true, length: {minimum: 3}
    validates :role_id, presence: true
    validates :email, presence: true, uniqueness: true, email: true
    validates :password, presence: true, length: {minimum: 3}

    def create_api_key
    	ApiKey.create :user => self
    end

    def password_to_md5_on_create
        self.password = Digest::MD5.hexdigest(self.password)
    end

    def password_to_md5_on_update
        unless self.password =~ /\A[0-9a-fA-F]{32}\z/ #isnotMD5?
            self.password = Digest::MD5.hexdigest(self.password)
        end
    end

    def self.create_from_model(hash)
    	error_messages = self.create(:name => hash[:name], :role_id => hash[:role_id], :password => hash[:password], :email => hash[:email]).errors.messages
      	if error_messages.to_a.length != 0
            return {errors: error_messages}, 400
        else
            return {response: 'User was created', user_id: self.last.id}, 201
        end	
    end

    def self.destroy_from_model(hash)
    	begin
            user = ApiKey.find_by_token(hash[:token]).user
            role = user.role.id
            if role == 1
                self.find(hash[:id]).destroy  
                return {response: "User #{hash[:id]} was deleted"}, 200
            elsif role == 2 && user.id == hash[:id].to_i
                self.find(hash[:id]).destroy  
                return {response: "User #{hash[:id]} was deleted"}, 200
            else
                return {response: "Only Admin or the owner account can request this action"}, 401
            end
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            token_user = ApiKey.find_by_token(hash[:token]).user
            role = token_user.role.id
            if role == 1
                user = self.find(hash[:id])
                user.assign_attributes(:name => hash[:name].nil? ? user.name : hash[:name], :role_id => hash[:role_id].nil? ? user.role_id : hash[:role_id], :password => hash[:password].nil? ? user.password : hash[:password], :email => hash[:email].nil? ? user.email : hash[:email])
            	if user.valid?
                	user.save
                  	return {response: "User #{hash[:id]} was updated"}, 200
                else
                  	error_messages = user.errors.messages
                  	return {errors: error_messages}, 400
                end
            elsif role == 2 && token_user.id == hash[:id].to_i
                user = self.find(hash[:id])
                user.assign_attributes(:name => hash[:name].nil? ? user.name : hash[:name], :role_id => hash[:role_id].nil? ? user.role_id : hash[:role_id], :password => hash[:password].nil? ? user.password : hash[:password], :email => hash[:email].nil? ? user.email : hash[:email])
                if user.valid?
                  	user.save
                  	return {response: "User #{hash[:id]} was updated"}, 200
                else
                  	error_messages = user.errors.messages
                  	return {errors: error_messages}, 400
                end
            else
                return {response: "Only Admin or the owner account can request this action"}, 401
            end
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end
    
end