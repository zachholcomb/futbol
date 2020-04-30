require_relative 'stat'

class LeagueStat < Stat
  attr_reader :stats_by_team

  def initialize(game_collection, team_collection, game_team_collection)
    super(game_collection, team_collection, game_team_collection)   
  end
  
  def count_of_teams
    @stats_by_team.keys.size
  end

  def best_offense
    @stats_by_team.max_by { |team_id| team_id[1][:total_scoring_avg]}[1][:team_name]
  end

  def worst_offense
    @stats_by_team.min_by { |team_id| team_id[1][:total_scoring_avg]}[1][:team_name]
  end

  def best_defense
    @stats_by_team.min_by { |team_id| team_id[1][:total_goals_allowed_avg]}[1][:team_name]
  end

  def worst_defense
    @stats_by_team.max_by { |team_id| team_id[1][:total_goals_allowed_avg]}[1][:team_name]
  end

  def highest_scoring_visitor
    @stats_by_team.max_by { |team_id| team_id[1][:away_scoring_avg]}[1][:team_name]
  end

  def highest_scoring_home_team
    @stats_by_team.max_by { |team_id| team_id[1][:home_scoring_avg]}[1][:team_name]
  end

  def lowest_scoring_visitor
    @stats_by_team.min_by { |team_id| team_id[1][:away_scoring_avg]}[1][:team_name]
  end

  def lowest_scoring_home_team
    @stats_by_team.min_by { |team_id| team_id[1][:home_scoring_avg]}[1][:team_name]
  end

  def winningest_team
    @stats_by_team.max_by do |team_id|
      team_id[1][:total_wins] / team_id[1][:total_games].to_f
    end[1][:team_name]
  end

  def best_fans
    @stats_by_team.max_by do |team_id|
      home_win_pct = team_id[1][:home_wins] / team_id[1][:home_games].to_f
      away_win_pct = team_id[1][:away_wins] / team_id[1][:away_games].to_f
      home_win_pct - away_win_pct
    end[1][:team_name]
  end

  def worst_fans
    worst = @stats_by_team.find_all do |team_id|
      home_win_pct = team_id[1][:home_wins] / team_id[1][:home_games].to_f
      away_win_pct = team_id[1][:away_wins] / team_id[1][:away_games].to_f
      home_win_pct < away_win_pct
    end
    worst.map { |team| team[1][:team_name] }
  end

end
