module ArtistsHelper
  def artists(item)
    item.full_display_names.present? ? [item.full_display_names.join(" and "), "by #{item.full_display_names.join(" and ")}"] : [""]
  end

  def artists_target(item)
    item.artists_full_names
  end

  def artists_abrv(item)
    item.artists_last
  end

  def dob_target(item)
    item.artists_dob
  end
end
