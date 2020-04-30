require 'csv'

module CSVLoadable  
  def load_csv(file_path, object)
    csv = CSV.read(file_path, headers: true, header_converters: :symbol)

    csv.map do |row|
      object.new(row)
    end
  end
end