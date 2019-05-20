class Api::V1::ProfilesController < Api::V1::BaseController
  # authorize_resource class: User

  expose :users, -> { User.where.not(id: current_resource_owner.id) }

  def me
    render json: current_resource_owner
  end

  def index
    render json: users
  end
end
