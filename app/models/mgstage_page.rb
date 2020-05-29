class MgstagePage < ApplicationRecord
  has_one :mgstage_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  after_save :create_or_update_item

  def create_or_update_item
    return unless raw_html_previously_changed?

    begin
      self.create_mgstage_item!
    rescue ActiveRecord::RecordInvalid => e
      self.mgstage_item = nil
    end
  end

  def item
    mgstage_item
  end
end
