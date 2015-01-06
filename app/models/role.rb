class Role < ActiveRecord::Base
	has_and_belongs_to_many :controller_actions
	has_many :users
	validates :name, presence: true, uniqueness: true

	def self.create_from_model(hash)
    	error_messages = self.create(:name => hash[:name]).errors.messages
      	if error_messages.to_a.length != 0
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('roles.create.response'), role_id: self.last.id}, 201
        end
    end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  
            return {response: I18n.t('roles.delete.response', id: hash[:id])}, 200
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            role = self.find(hash[:id])
            role.assign_attributes(:name => hash[:name].nil? ? role.name : hash[:name])
            if role.valid?
               	role.save
               	return {response: I18n.t('roles.update.response', id: hash[:id])}, 200
            else
               	error_messages = role.errors.messages
               	return {errors: error_messages}, 400
            end
        rescue Exception => e
            return {response: "#{e}"}, 404
        end
    end

end