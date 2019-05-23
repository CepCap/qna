class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy
  include Voteable
  include Commentable

  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  has_many_attached :files

  after_save { id = self.id }
  after_create :subscribe_author

  validates :title, :body, presence: true

  scope :created_today, -> { Question.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  def subscribed_users
    users = []
    subscriptions.each { |el| users << el.user }
    users
  end

  private

  def subscribe_author
    user.subscribe(self)
  end
end
