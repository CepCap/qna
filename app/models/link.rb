class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validate_link_url, on: :create
  validate :validate_link_url, on: :update

  URL_REGEXP = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  def to_gist?
    url.match?(/https:\/\/gist.github.com\/\w+\//)
  end

  private

  def validate_link_url
    errors.add(:url, 'Invalid url format') unless url.match?(URL_REGEXP)
  end
end
