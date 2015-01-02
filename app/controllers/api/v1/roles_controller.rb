module Api
    module V1
      class RolesController < ApplicationController
      	before_filter :restrict_access, :except => []
      end
  end
end