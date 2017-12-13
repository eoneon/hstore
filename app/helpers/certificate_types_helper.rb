module CertificateTypesHelper
  def missing_cert_clause(item)
    ["This piece does not come with a Certificate of Authenticity and we make no additional warranties"] if item.certificate_type.name == "missing certificate"
  end

  def cert_psa_dna(item)
    if item.properties["certificate_kind"].present?
      if item.properties["certificate_kind"] == "PSA/DNA authentication"
        ["PSA/DNA Authentication", "This piece is presented with PSA/DNA Authentication, which authenticates memorabilia using proprietary permanent invisible ink as well as a strand of synthetic DNA."]
      # else
      #   ""
      end
    end
  end

  def certificate(item)
    if item.properties["certificate_kind"].present?
      if item.properties["certificate_kind"] != "PSA/DNA authentication"
        # cert = [ item.properties["certificate_kind"], item.properties["certificate_issuer"] ].reject { |item| item.blank? }.join(" from ")
        # ["with #{cert}", "Includes #{cert}."]
        cert = [ item.properties["certificate_kind"], item.properties["certificate_issuer"] ].reject { |item| item.blank? }.join(" from ")
        ["with #{cert}", "Includes #{cert}."]
      # else
      #   [""]
      end
    end
  end

  def build_certificate(item)
    if certificate(item).present? || cert_psa_dna(item).present?
      #["with #{certificate(item)}", "Includes #{certificate(item)}."]
      #[ [ certificate(item)[0], certificate(item)[-1] ], [ cert_psa_dna(item).try([0]), cert_psa_dna(item).try([-1]) ] ].reject { |item| item.blank? }
      cert = [ certificate(item), cert_psa_dna(item) ].reject { |item| item.blank? }[0]
      [cert[0], cert[-1]]
    else
      [""]
    end
  end

  # def issuer(item)
  #   item.properties["issuer"] if item.properties && item.properties["issuer"].present?
  # end
  #
  # def authentication(item)
  #   if item.properties && coa(item).present?
  #     authentication = coa(item).split(" ").first
  #     authentication == "Letter" ? "LOA" : "#{authentication.capitalize}"
  #   # else
  #   #   ""
  #   end
  # end

  # def certificate(item)
  #   if item.certificate_type.present?
  #     item.properties["certificate_kind"].present? ? item.properties["certificate_kind"] : ""
  #   end
  # end

  # def coa(item)
  #   if item.properties && certificate(item).present?
  #     certificate(item)
  #   elsif issuer(item).present?
  #     "Certificate of Authenticity from #{item.properties["issuer"]}"
  #   # else
  #   #   ""
  #   end
  # end

  # def build_certificate(item)
  #   if coa(item).present?
  #     ["with #{coa(item)}", "Includes #{conditional_capitalize(coa(item))}."]
  #   else
  #     [""]
  #   end
  # end
end
