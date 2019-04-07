class AttachmentsController < ApplicationController
  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    if current_user.author_of?(attachment.record)
      attachment.record.files.each { |file| file.purge if file.id == params['id'] }
    end
  end
end
