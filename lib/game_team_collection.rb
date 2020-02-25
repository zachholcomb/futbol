require 'csv'
require_relative 'game_team'

class GameTeamCollection
  attr_reader :game_team_list

  def initialize(file_path)
    @game_team_list = create_game_teams(file_path)
  end

  def create_game_teams(file_path)
    csv = CSV.read(file_path, headers: true, header_converters: :symbol)

    csv.map do |row|
      GameTeam.new(row)
    end
  end
end
