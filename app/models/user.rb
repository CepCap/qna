class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, class_name: 'Question', foreign_key: :author_id
  has_many :answers, class_name: 'Answer', foreign_key: :author_id

  def is_author?(question_or_answer)
   if question_or_answer.is_a?(Question) || question_or_answer.is_a?(Answer)
      self.id == question_or_answer.author_id
    end
  end

end
