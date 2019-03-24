class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true

  def choose_best
    previous_best = Answer.find_by(best: true, question: self.question)
    if previous_best
      ActiveRecord::Base.transaction do
        self.update!(best: true)
        previous_best.update!(best: false)
      end
    else
      self.update!(best: true)
    end
  end
end
