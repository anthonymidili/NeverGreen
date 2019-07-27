module GalleriesHelper
  def medium_image(image)
    image.variant(combine_options: {
      auto_orient: true,
      gravity: "center",
      resize: "1000x1000^"
      }) # .processed.service_url
  end
end
