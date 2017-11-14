module ArtistsHelper
  def artists(item)
    item.artists_by_item.present? ? [item.artists_by_item.join(" and "), "by #{item.artists_by_item.join(" and ")}"] : [""]
  end
end
