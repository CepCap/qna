class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_questions, class_name: 'Question', foreign_key: :author_id

  def is_author?(question)
    self.id == question.author_id
  end

end
