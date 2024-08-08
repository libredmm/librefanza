module GenericItem
  extend ActiveSupport::Concern

  included do
    include Derivable
    prepend CoverImageOverridable

    belongs_to :movie, foreign_key: :normalized_id, primary_key: :normalized_id, optional: true
    after_save :create_or_update_movie
    after_destroy :destroy_obsolete_movie
  end

  def create_or_update_movie
    if normalized_id_previously_changed?
      old_movie = Movie.find_by(normalized_id: normalized_id_before_last_save)
      old_movie.destroy if old_movie && !old_movie.preferred_item
    end

    if movie
      movie.touch
    else
      create_movie!(normalized_id: self.normalized_id)
    end
  end

  def destroy_obsolete_movie
    movie = Movie.find_by(normalized_id: normalized_id)
    movie.destroy if movie && !movie.preferred_item
  end

  def attribute_names_for_serialization
    %w(actresses cover_image_url date description directors genres labels makers normalized_id review subtitle thumbnail_image_url title url volume sample_image_urls)
  end

  def preferred?
    movie.preferred_item == self
  end
end
