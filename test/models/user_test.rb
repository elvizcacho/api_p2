require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "an user cannot have a name with a length less than 3 characters" do
  	User.create(:name => "Ju")
  	puts "El nombre es valido? : #{User.create(:name => "Ju").valid?}"
  	assert User.last.name.length > 2
  end

  test 'user must have a role and name longer than 3 characters' do
    quantity_before_create = User.all.count
    User.create()
    User.create(:name => "a")
    User.create(:name => "Ana")
    User.create(:role_id => 1)
    quantity_after_create = User.all.count
    assert(quantity_before_create == quantity_after_create, "validations control the creation of users")
    User.create(:name => "Juan", :role_id => 1, :password => '1234', :email => 'email@gmail.com')
    quantity_after_create = User.all.count
    assert(quantity_before_create == quantity_after_create - 1, "creation passed all validation")
  end
end
