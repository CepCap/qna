class LinksController < ApplicationController
  expose :link

  authorize_resource

  def destroy
    if current_user&.author_of?(link.linkable)
      link.destroy
    end
  end
end
