class FanzaActress < ApplicationRecord
  include Derivable

  validates :fanza_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :raw_json, presence: true

  paginates_per 45

  def movies
    query = Movie.where("actress_names @> ARRAY[?]::varchar[]", name)
    query = query.or(Movie.where("actress_fanza_ids @> ARRAY[?]", fanza_id)) if fanza_id
    query
  end

  def derive_fields
    self.fanza_id = self.as_struct.id
    self.name = self.as_struct.name.strip
  end

  def as_struct
    RecursiveOpenStruct.new(raw_json, recurse_over_arrays: true)
  end

  def image_url
    self.as_struct.imageURL&.large || self.as_struct.imageURL&.small
  end

  def to_param
    self.fanza_id.to_s
  end

  def attributes
    {
      "name" => nil,
      "image_url" => nil,
    }
  end
end
