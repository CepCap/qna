class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  include Voteable

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  def choose_best
    previous_best = question.answers.find_by(best: true)
    ActiveRecord::Base.transaction do
      self.update!(best: true)
      author.awards << question.award if question.award.present?
      previous_best.update!(best: false) if previous_best
    end
  end
end
