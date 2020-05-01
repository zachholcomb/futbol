module Calculable
  def calculate_percentage_decimal(to_be_divided, divided_by)
    if divided_by == 0
      return 0.00
    else
      ((to_be_divided.to_f / divided_by).round(2))
    end
  end

  def calculate_percentage(to_be_divided, divided_by)
      if divided_by == 0
      return 0.00
    else
      ((to_be_divided.to_f / divided_by) * 100).round(2) 
    end
  end
end