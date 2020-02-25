require_relative 'game_collection'
require_relative 'game_team_collection'
require_relative 'team_collection'
require_relative './modules/helper_methods'

class SeasonStat
  include Helperable

  def initialize(game_collection, team_collection)
    @game_collection = game_collection
    @team_collection = team_collection
    @season_list = @game_collection.get_all_seasons
  end

  def count_of_season_games(season)
    get_season_games(season).size
  end

  def average_goals_per_game_per_season(season)
  total = 0
    get_season_games(season).each do |game|
      total += (game.home_goals + game.away_goals)
    end
    (total.to_f / count_of_season_games(season)).round(2)
  end

  def average_goals_by_season
    @season_list.reduce({}) do |season_goals, season|
      season_goals[season] = average_goals_per_game_per_season(season)
      season_goals
    end
  end

  def count_of_games_by_season
    @season_list.reduce({}) do |season_games_hash, season|
      season_games_hash[season] = count_of_season_games(season)
      season_games_hash
    end
  end

  def games_by_type(game_type, season)
    get_season_games(season).find_all do |game|
      game.type == game_type
    end
  end

  def get_team_data(season)
    @team_collection.teams_list.reduce({}) do |team_hash, team|
      team_hash[team.team_id.to_s] = {
         team_name: team.team_name,
         season_win_percent: team_win_percentage(team.team_id, 'Regular Season', season),
         postseason_win_percent: team_win_percentage(team.team_id, 'Postseason', season),
}
      team_hash
    end
  end

  def total_team_games_by_game_type(team_id, game_type, season)
    total_games = 0

    total_games += get_season_games(season).find_all do |game|
       game.away_team_id == team_id && game.type == game_type
     end.length

    total_games += get_season_games(season).find_all do |game|
       game.home_team_id == team_id  && game.type == game_type
     end.length

    total_games
  end

  def total_team_wins_by_game_type(team_id, game_type, season)
    wins = 0
    wins += get_season_games(season).find_all do |game|
      game.away_team_id == team_id && game.away_goals > game.home_goals && game.type == game_type
    end.length
    wins += get_season_games(season).find_all do |game|
      game.home_team_id == team_id && game.home_goals > game.away_goals && game.type == game_type
    end.length
  end

  def team_win_percentage(team_id, game_type, season)
    total_wins = total_team_wins_by_game_type(team_id, game_type, season).to_f
    total_games = total_team_games_by_game_type(team_id, game_type, season)
    if total_games == 0
      return 0.00
    else
      ((total_wins / total_games) * 100).round(2)
    end
  end

  def biggest_bust(season)
    team_bust = get_team_data(season).max_by do |team_id, team_info|
      (team_info[:season_win_percent] - team_info[:postseason_win_percent])
    end
    team_bust[1][:team_name]
  end

  def biggest_surprise(season)
    team_bust = get_team_data(season).max_by do |team_id, team_info|
      (team_info[:postseason_win_percent] - team_info[:season_win_percent])
    end
    team_bust[1][:team_name]
  end
end
