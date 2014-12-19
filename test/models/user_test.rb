require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "un usuario no puede tener campo de nombre menor a 3 letras" do
  	User.create(:name => "Ju")
  	puts "El nombre es valido? : #{User.create(:name => "Ju").valid?}"
  	assert User.last.name.length > 2
  end
end
