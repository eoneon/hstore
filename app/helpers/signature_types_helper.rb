module SignatureTypesHelper
  def unsigned(item, signature)
    [ "", "This piece is not signed." ] if signature == "unsigned"
  end

  def hand_signed(item, signature)
    [ signature, "#{signature} by the artist" ] if signature == "hand signed" || signature == "hand signed and thumb printed"
  end

  def autographed(item, signature)
    [ "#{signature} by #{artists(item)[-1]}", "#{signature} by #{artists(item)[-1]}" ] if signature == "autographed"
  end

  def authorized(item, signature)
    [ "signed", "bearing the #{signature} of the artist" ] if signature == "authorized signature"
  end

  def plate_signed(item, signature)
    ["plate signed", "bearing the #{signature} of the artist" ] if signature == "plate signature"
  end

  def build_signature(item)
    if item.properties["signature_kind"].present?
      signature = item.properties["signature_kind"]
      [unsigned(item, signature), hand_signed(item, signature), autographed(item, signature), authorized(item, signature), plate_signed(item, signature) ].reject { |m| m.blank?}[0]
    else
      [""]
    end
  end
end
