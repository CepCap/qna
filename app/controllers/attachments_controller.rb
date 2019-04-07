class AttachmentsController < ApplicationController
  def destroy
    if current_user.author_of?(record)
      record.files.each { |file| file.purge if file.filename.to_s == params['attachment_id'] }
    end
  end
end
