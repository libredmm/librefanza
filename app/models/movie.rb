class Movie < ApplicationRecord
  include Derivable

  self.primary_key = :normalized_id

  has_many :fanza_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :sod_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :mgstage_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :javlibrary_items, foreign_key: :normalized_id, primary_key: :normalized_id
  has_many :fc2_items, foreign_key: :normalized_id, primary_key: :normalized_id

  validates :normalized_id, presence: true, uniqueness: true
  validates :compressed_id, presence: true
  validates :date, presence: true

  paginates_per 30

  scope :solo, -> { where("array_length(actress_fanza_ids, 1) = 1") }

  def derive_fields
    self.compressed_id = Fanza::Id.compress(self.normalized_id)
    self.date = self.preferred_item&.date
    self.actress_fanza_ids = self.preferred_item&.actresses&.map(&:fanza_id)&.reject(&:nil?)
    self.actress_names = self.preferred_item&.actresses&.map(&:name)&.reject(&:nil?)
  end

  def preferred_item
    self.fanza_items.order(priority: :desc).order(date: :desc).first ||
      self.sod_items.first ||
      self.mgstage_items.first ||
      self.javlibrary_items.first ||
      self.fc2_items.first
  end

  def items
    self.fanza_items + self.sod_items + self.mgstage_items + self.javlibrary_items + self.fc2_items
  end
end
