class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many_attached :files

  validates :body, presence: true

  def choose_best
    previous_best = question.answers.find_by(best: true)
    ActiveRecord::Base.transaction do
      self.update!(best: true)
      previous_best.update!(best: false) if previous_best
    end
  end

  def delete_file(delete_file)
    files.each { |file| file.purge if file.filename.to_s == delete_file }
  end
end
