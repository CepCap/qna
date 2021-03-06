class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
  include Voteable
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  after_create :email_subscribers

  def choose_best
    previous_best = question.answers.find_by(best: true)
    ActiveRecord::Base.transaction do
      self.update!(best: true)
      user.awards << question.award if question.award.present?
      previous_best.update!(best: false) if previous_best
    end
  end

  private

  def email_subscribers
    SubscriptionJob.perform_later(question)
  end
end
