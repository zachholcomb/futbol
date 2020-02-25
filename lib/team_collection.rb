require 'csv'
require_relative 'team'

class TeamCollection
  attr_reader :teams_list

  def initialize(file_path)
    @teams_list = create_teams(file_path)
  end

  def create_teams(file_path)
    csv = CSV.read(file_path, headers: true, header_converters: :symbol)

    csv.map do |row|
      Team.new(row)
    end
  end
end
