class AttachmentsController < ApplicationController
  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    byebug
    if current_user.author_of?(attachment.record)
      attachment.record.files.find(attachment.id).purge
    end
  end
end
