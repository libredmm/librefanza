class JavlibraryPage < ApplicationRecord
  has_one :javlibrary_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

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
