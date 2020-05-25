module GenericItem
  extend ActiveSupport::Concern

  def attributes
    {
      "actresses" => nil,
      "cover_image_url" => nil,
      "date" => nil,
      "description" => nil,
      "directors" => nil,
      "genres" => nil,
      "labels" => nil,
      "makers" => nil,
      "normalized_id" => nil,
      "review" => nil,
      "subtitle" => nil,
      "thumbnail_image_url" => nil,
      "title" => nil,
      "url" => nil,
    }
  end
end
