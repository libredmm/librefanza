module GenericItem
  extend ActiveSupport::Concern

  included do
    belongs_to :movie, foreign_key: :normalized_id, primary_key: :normalized_id, optional: true
    after_save :recreate_movie
  end

  def recreate_movie
    return unless normalized_id_previously_changed?

    old_movie = Movie.find_by(normalized_id: normalized_id_before_last_save)
    old_movie.destroy if old_movie && !old_movie.preferred_item
    create_movie(normalized_id: self.normalized_id)
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
