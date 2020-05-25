class MgstagePage < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true
end
