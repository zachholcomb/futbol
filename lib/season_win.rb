require_relative 'team_collection'
require_relative 'game_team_collection'
require_relative 'game_collection'

class SeasonWin

  attr_reader :team_id

  def initialize(team_id)
    @team_id = team_id
  end

  def team_info(team_id)
    team_collection = TeamCollection.new('./data/teams.csv')
    team_collection.teams_list.reduce(Hash.new) do |acc, team|
      if team_id == team.team_id.to_s
        acc = {"team_id" => team.team_id.to_s,
               "franchise_id" => team.franchise_id.to_s,
               "team_name" => team.team_name,
               "abbreviation" => team.abbreviation,
               "link" => team.link}
      end
      acc
    end
  end

  def best_season(team_id)
    total_wins_by_team_per_season(team_id)
  end

  def game_id_by_season(team_id)
    game_collection = GameCollection.new('./data/games.csv')
    game_collection.games_list.reduce({}) do |acc, game|
      game_id = game.game_id if game.away_team_id.to_s == team_id || game.home_team_id.to_s == team_id
      next acc if game_id.nil?
      if acc.include?(game.season)
        acc[game.season] = acc[game.season] << game_id.to_s
      else
        acc[game.season] = [game_id.to_s]
      end
      acc
    end
  end

  def total_games_by_season(team_id)
    total_games = {}
    game_id_by_season(team_id).map do |season, game_id|
      total_games[season] = game_id.length
    end
    total_games
  end

  def winning_game_ids(team_id)
    game_team_collection = GameTeamCollection.new('./data/game_teams.csv')
    #array of winning game id's by team id
    game_team_collection.game_team_list.map do |game_team|
      if (game_team.team_id.to_s == team_id) && (game_team.result == "WIN")
        game_team.game_id.to_s
      end
    end.compact
  end

  def total_wins_by_team_per_season(team_id)
    wins = winning_game_ids(team_id).group_by do |game_id|
      game_id[0..3]
    end
    total_won_games = {}
    wins.map do |key, value|
      total_won_games[key] = value.length
    end
    max_value = total_won_games.max_by do |key, value|
      value
    end
    max_value.first + (max_value.first.to_i + 1).to_s
  end
end