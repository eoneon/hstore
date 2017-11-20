module CertificateTypesHelper
  def issuer(item)
    item.properties["issuer"] if item.properties && item.properties["issuer"].present?
  end

  def authentication(item)
    if item.properties && coa(item).present?
      authentication = coa(item).split(" ").first
      authentication == "Letter" ? "LOA" : "#{authentication.capitalize}"
    # else
    #   ""
    end
  end

  def certificate(item)
    item.properties["certificate_kind"].present? ? item.properties["certificate_kind"] : ""
  end

  def coa(item)
    if item.properties && certificate(item).present?
      certificate(item)
    elsif issuer(item).present?
      "Certificate of Authenticity from #{item.properties["issuer"]}"
    # else
    #   ""
    end
  end

  def build_certificate(item)
    if coa(item).present?
      ["with #{coa(item)}", "Includes #{conditional_capitalize(coa(item))}."]
    else
      [""]
    end
  end

  # def build_certificate(item)
  #   if item.properties["certificate_kind"].present?
  #     ["with #{item.properties["certificate_kind"]}", "Includes #{conditional_capitalize(item.properties["certificate_kind"])}."]
  #   elsif item.properties["issuer"].present?
  #     ["with Certificate of Authenticity from #{item.properties["issuer"]}", "Includes Certificate of Authenticity from #{item.properties["issuer"]}."]
  #   else
  #     [""]
  #   end
  # end
end
