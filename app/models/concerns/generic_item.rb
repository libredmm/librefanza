module GenericItem
  extend ActiveSupport::Concern

  included do
    belongs_to :movie, foreign_key: :normalized_id, primary_key: :normalized_id, optional: true
    after_save :create_or_update_movie
    after_touch :create_or_update_movie
  end

  def create_or_update_movie
    if self.movie
      self.movie.touch
    else
      create_movie(normalized_id: self.normalized_id)
    end
  end

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
