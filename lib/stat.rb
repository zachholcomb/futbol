require_relative 'game_collection'
require_relative 'game_team_collection'
require_relative 'team_collection'

class Stat
  attr_reader :games_by_season, :game_teams_by_season, :season_list
  def initialize(game_collection, team_collection, game_team_collection)
    @game_collection = game_collection
    @team_collection = team_collection
    @game_team_collection = game_team_collection
    @season_list = []
    @games_by_season = {}
    @game_teams_by_season = {}
  end

  def get_all_seasons
    @season_list = @game_collection.games_list.map { |game| game.season }.uniq
  end

  def season_games_by_all_seasons #need to test #combine these methods
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

  def get_season_games(season)
    @game_collection.games_list.find_all do |game|
      game.season == season
    end
  end

  def get_season_game_teams(season)
    @game_team_collection.game_team_list.find_all do |game_team|
      game_team.game_id[0..3] == season[0..3]
    end
  end

  def coaches_by_season(season)
    @game_teams_by_season[season].map do |game|
      game.head_coach
    end.uniq
  end

  def get_team_ids_by_season(season)
    @game_teams_by_season[season].map do |game_team|
      game_team.team_id.to_s
    end.uniq
  end

  def get_tackles_by_team_season(team_id, season)
    team_tackles = 0
    @game_teams_by_season[season].each do |game_team|
      if game_team.team_id.to_s == team_id
        team_tackles += game_team.tackles
      end
    end
    team_tackles
  end

  def get_goals_by_team_season(team_id, season)
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

  def team_shots_to_goal_ratio_by_season(team_id, season)
    total_goals = get_goals_by_team_season(team_id, season).to_f
    total_shots = get_shots_by_team_season(team_id, season)
    (total_shots / total_goals).round(3)
  end

  def coach_win_percentage_by_season(coach, season)
    win_total = get_coach_wins_by_season(coach, season).to_f
    total_games = get_total_coach_games_by_season(coach, season)
    ((win_total / total_games) * 100).round(2)
  end
end
