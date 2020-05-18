class FanzaItem < ApplicationRecord
  validates :content_id, uniqueness: true
end
