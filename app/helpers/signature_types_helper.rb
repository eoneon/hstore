module SignatureTypesHelper
  def build_signature(item)
    if item.properties["signature_kind"].present?
      signature_kind = item.properties["signature_kind"]
      if signature_kind == "unsigned"
        [ "", "This piece is not signed." ]
      elsif signature_kind == "hand signed" || signature_kind == "hand signed and thumb printed"
        [ signature_kind, "#{signature_kind} by the artist" ]
      elsif signature_kind == "plate signature" || signature_kind == "authorized signature"
        [ "signed", "bearing the #{signature_kind} of the artist" ]
      elsif signature_kind == "autographed"
        [ "#{signature_kind} by #{artists[-1]}", "#{signature_kind} by #{artists[-1]}" ]
      end
    else
      [""]
    end
  end
end
