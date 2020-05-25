class FanzaActress < ApplicationRecord
  include Derivable

  validates :id_fanza, presence: true, uniqueness: true
  validates :name, presence: true
  validates :raw_json, presence: true

  paginates_per 45

  def derive_fields
    self.id_fanza = self.as_struct.id
    self.name = self.as_struct.name.strip
  end

  def as_struct
    RecursiveOpenStruct.new(raw_json, recurse_over_arrays: true)
  end

  def image_url
    self.as_struct.imageURL&.large || self.as_struct.imageURL&.small
  end

  def to_param
    self.id_fanza.to_s
  end

  def attributes
    {
      "name" => nil,
      "image_url" => nil,
    }
  end
end
