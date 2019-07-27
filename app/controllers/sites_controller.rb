class SitesController < ApplicationController
  def home
    @songs = Song.all
    @galleries = Gallery.all
  end

  def about
  end
end
