class Fc2Page < ApplicationRecord
  has_one :fc2_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  validate :html_should_contain_header

  def html_should_contain_header
    unless raw_html.downcase.include? "items_article_header"
      errors.add(:raw_html, "does not contain item header")
    end
  end

  after_save :create_or_update_item

  def create_or_update_item
    return unless raw_html_previously_changed?

    begin
      self.create_fc2_item!
    rescue ActiveRecord::RecordInvalid => e
      self.fc2_item = nil
    end
  end

  def item
    fc2_item
  end
end
