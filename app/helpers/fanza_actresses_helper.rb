module FanzaActressesHelper
  def fake_image_url(actress)
    "https://dummyimage.com/125x125&text=#{actress.name}"
  end
end
