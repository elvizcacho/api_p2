class Role < ActiveRecord::Base
	has_and_belongs_to_many :controller_actions
	has_many :users
	validates :name, presence: true, uniqueness: true

    def self.create_from_model(hash)
    	error_messages = self.create(:name => hash[:name]).errors.messages #creates role or gets the error messsages
      	if error_messages.to_a.length != 0  #If there are errors I return them
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('roles.create.response'), role_id: self.last.id}, 201
        end
    end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  #deletes this role
            return {response: I18n.t('roles.delete.response', id: hash[:id])}, 200
        rescue Exception => e #If role is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            role = self.find(hash[:id]) #gets the role
            role.assign_attributes(:name => hash[:name].nil? ? role.name : hash[:name]) #assign the model attributes but not save
            if role.valid? #valids the attributes
               	role.save  #saves the attributes into table roles
               	return {response: I18n.t('roles.update.response', id: hash[:id])}, 200
            else
               	error_messages = role.errors.messages  #if there are errors, these ones are returned
               	return {errors: error_messages}, 400
            end
        rescue Exception => e #If role is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.get_permissions(hash)
        role = self.find(hash[:id])  #gets the role
        action_ids = role.controller_actions.ids #gets the action ids associated to the role
        return action_ids, 200
    end

    def self.set_permissions(hash)
        role = self.find(hash[:id]) #gets the role
        actions = role.controller_actions #gets the actions associated to the role
        role.controller_actions.delete(actions) #deletes all actions associated to the role
        for action_id in hash[:permissions].split(',') #gets the array of permissions and associates it to the role
            role.controller_actions << ControllerAction.find(action_id.to_i)
        end
        return {response: "Role permissions #{role.controller_actions.length} were set"}, 200
    end

    def self.search(search)
        search_condition = "%" + search + "%"
        self.where('name LIKE ?', search_condition)
    end

end