module MoviesHelper
  def to_items(movies_or_items)
    case movies_or_items.first
    when Movie
      movies_or_items.reject(&:is_hidden?).map(&:preferred_item)
    else
      movies_or_items.reject { |item| item.movie.is_hidden? }
    end
  end
end
