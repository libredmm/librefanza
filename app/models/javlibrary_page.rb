class JavlibraryPage < ApplicationRecord
  has_one :javlibrary_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  validate :html_should_not_be_challenged

  def html_should_not_be_challenged
    if raw_html.include? "challenge-form"
      errors.add(:raw_html, "is challenged")
    end
  end

  after_save :create_item
  after_touch :create_item

  def create_item
    if self.javlibrary_item
      self.javlibrary_item.touch
    else
      begin
        self.create_javlibrary_item!
      rescue ActiveRecord::RecordInvalid => e
        self.javlibrary_item = nil
      end
    end
  end
end
