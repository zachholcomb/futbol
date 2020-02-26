require_relative 'game_collection'
require_relative 'game_team_collection'
require_relative 'team_collection'
require_relative './modules/helper_methods'

class SeasonStat
  include Helperable

  def initialize(game_collection, team_collection, game_team_collection)
    @game_collection = game_collection
    @team_collection = team_collection
    @game_team_collection = game_team_collection
    @season_list = []
    @games_by_season = {}
    @game_teams_by_season = {}
    @coach_win_data = {}
  end

  def get_all_seasons
    @season_list = @game_collection.games_list.map { |game| game.season }.uniq
  end

  def season_games_by_all_seasons #need to test
    @season_list.reduce({}) do |acc, season|
      acc[season] = get_season_games(season)
      @games_by_season = acc
    end
  end

  def season_game_teams_by_all_seasons #need to test
    @season_list.reduce({}) do |acc, season|
      acc[season] = get_season_game_teams(season)
      @game_teams_by_season = acc
    end
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

  def total_team_games_by_game_type(team_id, game_type, season)
    total_games = 0

    total_games += @games_by_season[season].find_all do |game|
       game.away_team_id == team_id && game.type == game_type
     end.length

    total_games += @games_by_season[season].find_all do |game|
       game.home_team_id == team_id  && game.type == game_type
     end.length

    total_games
  end

  def total_team_wins_by_game_type(team_id, game_type, season)
    wins = 0
    wins += @games_by_season[season].find_all do |game|
      game.away_team_id == team_id && game.away_goals > game.home_goals && game.type == game_type
    end.length
    wins += @games_by_season[season].find_all do |game|
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

  def coaches_by_season(season)
    @game_teams_by_season[season].map do |game|
      game.head_coach
    end.uniq
  end

  def get_coach_wins_by_season(coach, season)
    @game_teams_by_season[season].find_all do |game_team|
      game_team.head_coach == coach && game_team.result == "WIN"
    end.length
  end

  def get_total_coach_games_by_season(coach, season)
    @game_teams_by_season[season].find_all do |game_team|
      game_team.head_coach == coach
    end.length
  end

  def coach_win_percentage_by_season(coach, season)
    win_total = get_coach_wins_by_season(coach, season).to_f
    total_games = get_total_coach_games_by_season(coach, season)
    ((win_total / total_games) * 100).round(2)
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

  def get_team_ids_by_season(season)
    @game_teams_by_season[season].map do |game_team|
      game_team.team_id
    end.uniq
  end

  def get_team_name(team_id)
    team_name_by_id = @team_collection.teams_list.find do |team|
      team.team_id == team_id
    end
    team_name_by_id.team_name
  end

  def get_tackles_by_team_season(team_id, season)#refactor to a reduce
    team_tackles = 0
    @game_teams_by_season[season].each do |game_team|
      if game_team.team_id.to_s == team_id
        team_tackles += game_team.tackles
      end
    end
    team_tackles
  end

  def get_goals_by_team_season(team_id, season)#refactor to a reduce
    team_goals = 0
    @game_teams_by_season[season].each do |game_team|
      if game_team.team_id.to_s == team_id
        team_goals += game_team.goals
      end
    end
    team_goals
  end

  def get_shots_by_team_season(team_id, season)
    team_shots = 0
    @game_teams_by_season[season].each do |game_team|
      if game_team.team_id.to_s == team_id
        team_shots += game_team.shots
      end
    end
    team_shots
  end

  def team_shots_to_goal_ratio_by_season(team_id, season)
    total_goals = get_goals_by_team_season(team_id, season).to_f
    total_shots = get_shots_by_team_season(team_id, season)
    (total_shots / total_goals).round(3)
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
