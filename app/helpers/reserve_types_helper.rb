module ReserveTypesHelper
  def prices(item)
    if item.properties.present?
      [item.properties["reserve"].to_i, item.retail] if item.properties["reserve"].present?
    end
  end

  def reserve_clause(item)
    reserve_arr = [["reserve price", prices(item)[0]], ["retail price", prices(item)[-1]]].sort {|a, b| a[-1] <=> b[-1]}.reject {|arr| arr[-1] == 0}.map {|arr| [arr[0], number_to_currency(arr[-1], precision: 0)]}
    title_clause = "(Original #{reserve_arr[-1].join(" was ")})."
    body_clause = reserve_arr.count == 2 ? "Original info provided shows this piece had a #{reserve_arr[0].join(" of ")} and a #{reserve_arr[-1].join(" of ")}." : "Original info provided shows this piece had a #{reserve_arr[0].join(" of ")}."
    [title_clause, body_clause]
  end
end
