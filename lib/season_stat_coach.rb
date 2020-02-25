require_relative 'game_collection'
require_relative 'game_team_collection'
require_relative 'team_collection'

class SeasonStatCoach

  def initialize(game_team_collection)
    @game_team_collection = game_team_collection
  end

  def get_season_game_teams(season)
    @game_team_collection.game_team_list.find_all do |game_team|
      game_team.game_id[0..3] == season[0..3]
    end
  end

  def coaches_by_season(season)
    get_season_game_teams(season).map do |game|
      game.head_coach
    end.uniq
  end

  def get_coach_wins_by_season(coach, season)
    get_season_game_teams(season).find_all do |game_team|
      game_team.head_coach == coach && game_team.result == "WIN"
    end.length
  end

  def get_total_coach_games_by_season(coach, season)
    get_season_game_teams(season).find_all do |game_team|
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
end
