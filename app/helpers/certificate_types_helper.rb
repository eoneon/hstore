module CertificateTypesHelper
  def build_certificate(item)
    if item.properties["certificate_kind"].present?
      ["with #{item.properties["certificate_kind"]}", "Includes #{conditional_capitalize(item.properties["certificate_kind"])}."]
    elsif item.properties["issuer"].present?
      ["with Certificate of Authenticity from #{item.properties["issuer"]}", "Includes Certificate of Authenticity from #{item.properties["issuer"]}."]
    else
      [""]
    end
  end
end
