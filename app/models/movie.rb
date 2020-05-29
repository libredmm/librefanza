class Movie < ApplicationRecord
  include Derivable

  has_many :fanza_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :mgstage_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :javlibrary_items, foreign_key: :normalized_id, primary_key: :normalized_id

  validates :normalized_id, presence: true, uniqueness: true
  validates :compressed_id, presence: true

  def derive_fields
    self.compressed_id = Fanza::Id.compress(self.normalized_id)
    self.date = self.preferred_item.date
  end

  def preferred_item
    self.fanza_items.order(date: :desc).first ||
      self.mgstage_items.first ||
      self.javlibrary_items.first
  end
end
