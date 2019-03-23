class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true

  def self.choose_best(previous_best, answer)
    ActiveRecord::Base.transaction do
      previous_best.update!(best: false)
      answer.update!(best: true)
    end
  end
end
