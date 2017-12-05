module ArtistsHelper
  #change name: artists_full_names
  def artists(item)
    item.full_display_names.present? ? [item.full_display_names.join(" and "), "by #{item.full_display_names.join(" and ")}"] : [""]
  end

  #change name: artists_last_names
  def artists_last(item)
    item.last_name.present? ? [item.last_name.join(" and "), "by #{item.last_name.join(" and ")}"] : [""]
  end

  #this might be obsolete once I remove the second array item from above method
  def artists_inv(item)
    "#{artists(item)[0]}" if artists(item).present?
  end

  #this might also be obsolete -> same as artists(item)[0]
  def artists_target(item)
    item.artists_full_names
  end

  #this might be made obsolete by artists_last(item)
  def artists_abrv(item)
    item.artists_last
  end

  #this needs to be reconsidered
  def dob_target(item)
    item.artists_dob
  end
end
