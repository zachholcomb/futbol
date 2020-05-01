require_relative 'stat'

class CoachStat < Stat
  attr_reader :game_collection, :team_collection, :game_team_collection

  def initialize(game_collection, team_collection, game_team_collection)
    super(game_collection, team_collection, game_team_collection)
  end

  def coaches_by_season(season)
    @game_teams_by_season[season].map do |game|
      game.head_coach
    end.uniq
  end

  def get_total_coach_games_by_season(coach, season)
    @game_teams_by_season[season].find_all do |game_team|
      game_team.head_coach == coach
    end.length
  end
  
  def get_coach_wins_by_season(coach, season)
    @game_teams_by_season[season].find_all do |game_team|
      game_team.head_coach == coach && game_team.result == "WIN"
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