class AwardsController < ApplicationController
  expose :awards, -> { current_user.awards }

  authorize_resource
end
