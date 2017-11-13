module ArtistsHelper
  def artists(item)
    artists = item.artist_ids.map { |a| Artist.find(a).full_name }
    artists.present? ? [artists.join(" and "), "by #{artists.join(" and ")}"] : [""]
  end
end
