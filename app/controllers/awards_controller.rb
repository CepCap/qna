class AwardsController < ApplicationController
  expose :awards, -> { current_user.awards }
end
