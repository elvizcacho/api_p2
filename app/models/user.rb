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
        self.password = Digest::MD5.hexdigest(self.password)
    end

    def self.create_from_model(hash)
    	error_messages = self.create(:name => hash[:name], :role_id => hash[:role_id], :password => hash[:password], :email => hash[:email]).errors.messages
      	if error_messages.to_a.length != 0
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('users.create.response'), user_id: self.last.id}, 201
        end	
    end

    def self.destroy_from_model(hash)
    	begin
            user = ApiKey.find_by_token(hash[:token]).user
            role = user.role.id
            if role == 1 || (role == 2 && user.id == hash[:id].to_i)
                self.find(hash[:id]).destroy  
                return {response: I18n.t('users.delete.response', id: hash[:id])}, 200
            else
                return {response: I18n.t('users.delete.error1')}, 401
            end
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            token_user = ApiKey.find_by_token(hash[:token]).user
            role = token_user.role.id
            if role == 1 || (role == 2 && token_user.id == hash[:id].to_i)
                user = self.find(hash[:id])
                role_id = role != 1 ? user.role_id : hash[:role_id].nil? ? user.role_id : hash[:role_id] #Only admin can change the user role
                user.assign_attributes(:name => hash[:name].nil? ? user.name : hash[:name], :role_id => role_id, :password => user.password, :email => hash[:email].nil? ? user.email : hash[:email])
            	if user.valid?
                	user.save
                  	return {response: I18n.t('users.update.response', id: hash[:id])}, 200
                else
                  	error_messages = user.errors.messages
                  	return {errors: error_messages}, 400
                end
            else
                return {response: I18n.t('users.update.error1')}, 401
            end
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end

    def self.update_password(hash)
        begin
            token_user = ApiKey.find_by_token(hash[:token]).user
            role = token_user.role.id
            if role == 1 || (role == 2 && token_user.id == hash[:id].to_i)
                user = self.find(hash[:id])
                if hash[:new_password] && hash[:current_password] && user.password == Digest::MD5.hexdigest(hash[:current_password])
                    user.assign_attributes(:name => user.name, :role_id => user.role_id, :password => hash[:new_password], :email => user.email)
                    if user.valid?
                        user.save
                        return {response: I18n.t('users.update_password.response', id: hash[:id])}, 200
                    else
                        error_messages = user.errors.messages
                        return {errors: error_messages}, 400 
                    end
                else
                   return {errors: I18n.t('users.update_password.error1')}, 401
                end
            else
                return {response: I18n.t('users.update_password.error2')}, 401
            end
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end
    
end