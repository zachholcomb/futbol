require_relative 'stat'
require_relative './modules/helper_methods'

class SeasonStat < Stat
  include Helperable

  def initialize(game_collection, team_collection, game_team_collection)
    super(game_collection, team_collection, game_team_collection)
    @coach_win_data = {}
  end

  def count_of_season_games(season)
    @games_by_season[season].size
  end

  def average_goals_per_game_per_season(season)
  total = 0
    @games_by_season[season].each do |game|
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
    @games_by_season[season].find_all do |game|
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

  def create_coach_win_data_by_season(season)
    coaches_by_season(season).reduce({}) do |acc, coach|
      acc[coach] = coach_win_percentage_by_season(coach, season)
      acc
    end
  end

  def winningest_coach(season)
    best_coach = create_coach_win_data_by_season(season).max_by do |coach, coach_wins|
      coach_wins
    end
    best_coach[0]
  end

  def worst_coach(season)
    worst_coach = create_coach_win_data_by_season(season).min_by do |coach, coach_wins|
      coach_wins
    end
    worst_coach[0]
  end

  def create_team_data_by_season(season)
    get_team_ids_by_season(season).reduce({}) do |acc, team_id|
      acc[team_id.to_s] = {
        team_name: get_team_name(team_id),
        goal_ratio: team_shots_to_goal_ratio_by_season(team_id.to_s, season),
        tackles: get_tackles_by_team_season(team_id.to_s, season)
      }
      acc
    end
  end

  def most_accurate_team(season)
    accurate_team = create_team_data_by_season(season).min_by do |team, team_data|
      team_data[:goal_ratio]
    end
    accurate_team[1][:team_name]
  end

  def least_accurate_team(season)
    inaccurate_team = create_team_data_by_season(season).max_by do |team, team_data|
      team_data[:goal_ratio]
    end
    inaccurate_team[1][:team_name]
  end

  def most_tackles(season)
    team_tackles = create_team_data_by_season(season).max_by do |team, team_data|
      team_data[:tackles]
    end
    team_tackles[1][:team_name]
  end

  def fewest_tackles(season)
    team_tackles = create_team_data_by_season(season).min_by do |team, team_data|
      team_data[:tackles]
    end
    team_tackles[1][:team_name]
  end
end
