class LinksController < ApplicationController
  expose :link

  def destroy
    if current_user&.author_of?(link.linkable.find(params[:parent_id]))
      link.destroy
    end
  end
end
