class SodPage < ApplicationRecord
  has_one :sod_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  validate :html_should_contain_videos

  def html_should_contain_videos
    unless raw_html.downcase.include? "middle_videos"
      errors.add(:raw_html, "does not contain videos")
    end
  end

  after_save :create_or_update_item

  def create_or_update_item
    return unless raw_html_previously_changed?

    begin
      self.create_sod_item!
    rescue ActiveRecord::RecordInvalid => e
      self.sod_item = nil
    end
  end

  def item
    sod_item
  end
end
