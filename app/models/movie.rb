class Movie < ApplicationRecord
  include Derivable

  self.primary_key = :normalized_id

  has_many :fanza_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :mgstage_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :javlibrary_items, foreign_key: :normalized_id, primary_key: :normalized_id

  validates :normalized_id, presence: true, uniqueness: true
  validates :compressed_id, presence: true
  validates :date, presence: true

  paginates_per 30

  def derive_fields
    self.compressed_id = Fanza::Id.compress(self.normalized_id)
    self.date = self.preferred_item&.date
    self.actress_fanza_ids = self.preferred_item&.actresses&.map(&:fanza_id)&.reject(&:nil?)
    self.actress_names = self.preferred_item&.actresses&.map(&:name)&.reject(&:nil?)
  end

  def preferred_item
    self.mgstage_items.first ||
      self.fanza_items.order(date: :desc).first ||
      self.javlibrary_items.first
  end
end
