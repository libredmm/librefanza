class MgstagePage < ApplicationRecord
  has_one :mgstage_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  after_save :create_or_update_item
  after_touch :create_or_update_item

  def create_or_update_item
    if self.mgstage_item
      self.mgstage_item.touch
    else
      begin
        self.create_mgstage_item!
      rescue ActiveRecord::RecordInvalid => e
        self.mgstage_item = nil
      end
    end
  end

  def item
    mgstage_item
  end
end
