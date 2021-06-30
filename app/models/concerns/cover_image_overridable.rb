module CoverImageOverridable
  extend ActiveSupport::Concern

  def cover_image_url
    movie.cover_image_url ? "https://imageproxy.libredmm.com/#{movie.cover_image_url}" : super
  end

  def thumbnail_image_url
    movie.cover_image_url ? "https://imageproxy.libredmm.com/cx.53/#{movie.cover_image_url}" : super
  end
end
