class FanzaActress < ApplicationRecord
  include Derivable

  validates :id_fanza, presence: true, uniqueness: true
  validates :name, presence: true
  validates :raw_json, presence: true

  paginates_per 45

  def movies
    joins = Movie.left_joins(:fanza_items, :mgstage_items, :javlibrary_items)
    if id_fanza
      query = joins.where(%{fanza_items.raw_json @> '{"iteminfo": {"actress": [{"id": #{id_fanza}}]}}'})
    else
      query = joins.where(%{fanza_items.raw_json @> '{"iteminfo": {"actress": [{"name": "#{name}"}]}}'})
    end
    query
      .or(joins.where("mgstage_items.actress_names @> ARRAY[?]::varchar[]", name))
      .or(joins.where("javlibrary_items.actress_names @> ARRAY[?]::varchar[]", name))
      .distinct
  end

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
