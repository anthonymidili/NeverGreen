module ProjectsHelper
  def display_track(track)
    if track.variable?
      link_to image_tag(track.variant(combine_options: {
        auto_orient: true,
        gravity: "center",
        resize: "400x400^"
        })), rails_blob_path(track, disposition: :attachment)
    elsif track.previewable?
      link_to image_tag(track.preview(resize: '400x400')), rails_blob_path(track, disposition: :attachment)
    elsif track.image?
      link_to image_tag(track, width: 400), track
    else
      link_to track.filename, rails_blob_path(track, disposition: :attachment)
    end
  end
end
