module TracksHelper
  def display_track(track)
    if track.variable?
      image_tag(track.variant(combine_options: {
        auto_orient: true,
        gravity: "center",
        resize: "400x400^"
        }))
    elsif track.previewable?
      image_tag(track.preview(resize: '400x400'))
    elsif track.image?
      image_tag(track, width: 400)
    else
      track.filename
    end
  end
end
