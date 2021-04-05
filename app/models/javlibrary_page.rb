class JavlibraryPage < ApplicationRecord
  has_one :javlibrary_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  validate :html_should_not_be_challenged
  validate :html_should_not_be_denied_access

  def html_should_not_be_challenged
    if raw_html.downcase.include? "challenge-form"
      errors.add(:raw_html, "is challenged")
    end
  end

  def html_should_not_be_denied_access
    if raw_html.downcase.include? "access denied"
      errors.add(:raw_html, "is denied access")
    end
  end

  after_save :create_or_update_item

  def create_or_update_item
    return unless raw_html_previously_changed?

    begin
      self.create_javlibrary_item!
    rescue ActiveRecord::RecordInvalid => e
      self.javlibrary_item = nil
    end
  end

  def item
    javlibrary_item
  end
end
