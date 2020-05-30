module MoviesHelper
  def to_items(movies_or_items)
    movies_or_items.first.is_a?(Movie) ? movies_or_items.map(&:preferred_item) : movies_or_items
  end
end
