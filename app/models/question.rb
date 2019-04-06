class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_many_attached :files

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :title, :body, presence: true

  def delete_file(delete_file)
    files.each { |file| file.purge if file.filename.to_s == delete_file }
  end
end
