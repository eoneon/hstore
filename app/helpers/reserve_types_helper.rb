module ReserveTypesHelper
  def prices(item)
    if item.properties.present?
      [item.properties["reserve"].to_i, item.retail] if item.properties["reserve"].present?
    end
  end

  def reserve_clause(item)
    if item.properties.present? && item.invoice.name == "RR3" && prices(item)[0] + prices(item)[-1] > 0
      reserve_arr = [["reserve price", prices(item)[0]], ["retail price", prices(item)[-1]]].sort {|a, b| a[-1] <=> b[-1]}.reject {|arr| arr[-1] == 0}.map {|arr| [arr[0], number_to_currency(arr[-1], precision: 0)]}
      title_clause = "(Original #{reserve_arr[-1].join(" was ")})." if prices(item).sort[1] >= 1000
      body_clause = reserve_arr.count == 2 ? "The original information provided showed this piece had a #{reserve_arr[0].join(" of ")} and a #{reserve_arr[-1].join(" of ")}." : "The original information provided showed this piece had a #{reserve_arr[0].join(" of ")}."
      [title_clause, body_clause]
    else
      [""]
    end
  end
end
