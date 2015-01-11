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

    def self.get_permissions(params)
        
        controller_request = params[:controller].scan(/v\d\.{0,1}\d*\/([^\/]+)$/)[0][0] #gets the controller name
        controller_db = ControllerAction.where(:name => controller_request, :controller_action_id => nil).first #gets the controller from db
        action_db = ControllerAction.where(:name => params[:action], :controller_action_id => controller_db.id).first #gets the actions associated to controller_db
        permissions = action_db.controller_actions.select(:id) #gets the permissions of the action
        array = [] #creates an empty array
        for permission in permissions #gets the id of each permission
            array << permission.id
        end

        role = ApiKey.find_by_token(params[:token]).user.role #gets role by token
        role_permissions = role.controller_actions #gets role permissions
        array2 = [] #creates an empty array
        for role_permission in role_permissions #gets the ids of each permission
            array2 << role_permission.id
        end
        return array, array2 #return the permissions of the action and the role permissions
    end

    def create_api_key #when an user is created its token is created after save it
    	ApiKey.create :user => self
    end

    def password_to_md5_on_create #encrypts password before save
        self.password = Digest::MD5.hexdigest(self.password)
    end

    def password_to_md5_on_update #encrypts password before update
        self.password = Digest::MD5.hexdigest(self.password)
    end

    def self.create_from_model(hash)
    	error_messages = self.create(:name => hash[:name], :role_id => hash[:role_id], :password => hash[:password], :email => hash[:email]).errors.messages #creates an user and gets the errors If they exist
      	if error_messages.to_a.length != 0 #are there errors?
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('users.create.response'), user_id: self.last.id}, 201
        end	
    end

    def self.destroy_from_model(hash)
        permissions, role_permissions = get_permissions(:controller => hash[:controller], :action => hash[:action], :token => hash[:token]) #gets the permissions of the role associated by user token and the action
        #permissions
            destroy_other_users = role_permissions.include?(permissions[0]) #Does role have access to this?
            destroy_itself = role_permissions.include?(permissions[1]) #Does role have access to this?
        #end
    	begin
            user = ApiKey.find_by_token(hash[:token]).user #gets the user by token
            if destroy_other_users || (destroy_itself && user.id == hash[:id].to_i)
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
        permissions, role_permissions = get_permissions(:controller => hash[:controller], :action => hash[:action], :token => hash[:token]) #gets the permissions of the role associated by user token and the action
        #permissions
            update_role_id = role_permissions.include?(permissions[0]) #Does role have access to this?
            update_password = role_permissions.include?(permissions[1]) #Does role have access to this?
            update_other_users = role_permissions.include?(permissions[2]) #Does role have access to this?
            update_itself = role_permissions.include?(permissions[3]) #Does role have access to this?
        #end
    	begin
            user_id = ApiKey.find_by_token(hash[:token]).user.id #gets the user by token
            if update_other_users || (update_itself && user_id == hash[:id].to_i)
                user = self.find(hash[:id])
                role_id = !update_role_id ? user.role_id : hash[:role_id].nil? ? user.role_id : hash[:role_id] #Only roles with "update_role_id" permission can change the user role
                password = !update_password ? user.password : hash[:password].nil? ? user.password : hash[:password] #Only roles with "update_password" permission can change the user password
                user.assign_attributes(:name => hash[:name].nil? ? user.name : hash[:name], :role_id => role_id, :password => password, :email => hash[:email].nil? ? user.email : hash[:email])
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
        permissions, role_permissions = get_permissions(:controller => hash[:controller], :action => hash[:action], :token => hash[:token]) #gets the permissions of the role associated by user token and the action
        #permissions
            update_other_users_password = role_permissions.include?(permissions[0]) #Does role have access to this?
            update_own_user_password = role_permissions.include?(permissions[1]) #Does role have access to this?
        #end
        begin
            user_id = ApiKey.find_by_token(hash[:token]).user.id #gets the user by tokencd
            if update_other_users_password || (update_own_user_password && user_id == hash[:id].to_i)
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