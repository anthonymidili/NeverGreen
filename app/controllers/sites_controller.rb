class SitesController < ApplicationController
  def home
    @songs = Song.all
  end

  def about
  end
end
