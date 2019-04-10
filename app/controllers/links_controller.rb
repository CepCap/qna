class LinksController < ApplicationController
  expose :link

  def destroy
    if current_user&.author_of?(Object.const_get(link.linkable_type).find(params[:parent_id]))
      link.destroy
    end
  end
end
