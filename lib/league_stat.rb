class LeagueStat

  attr_reader :stats_by_team

  def initialize(team_collection, game_collection)
    @team_collection = team_collection
    @game_collection = game_collection
    @stats_by_team = Hash.new do |hash, key|
      hash[key] = Hash.new { |hash, key| hash[key] = 0 }
    end
    create_teams(@team_collection.teams_list)
    create_league_stats(@game_collection.games_list)
    create_scoring_averages
  end

  def create_teams(teams)
    teams.each do |team|
      stats_by_team[team.team_id][:team_name] = team.team_name
    end
  end

  def create_league_stats(games)
    games.each do |game|
      self.game_stats_away(game)
      self.game_stats_home(game)
    end
  end

  def game_stats_away(game)
    stats_by_team[game.away_team_id][:away_goals] += game.away_goals
    stats_by_team[game.away_team_id][:away_goals_allowed] += game.home_goals
    stats_by_team[game.away_team_id][:total_games] += 1
    stats_by_team[game.away_team_id][:away_games] += 1
    if game.away_goals > game.home_goals
      stats_by_team[game.away_team_id][:away_wins] += 1
      stats_by_team[game.away_team_id][:total_wins] += 1
    elsif game.away_goals < game.home_goals
      stats_by_team[game.away_team_id][:away_losses] += 1
      stats_by_team[game.away_team_id][:total_losses] += 1
    end
  end

  def game_stats_home(game)
    stats_by_team[game.home_team_id][:home_goals] += game.home_goals
    stats_by_team[game.home_team_id][:home_goals_allowed] += game.away_goals
    stats_by_team[game.home_team_id][:total_games] += 1
    stats_by_team[game.home_team_id][:home_games] += 1
    if game.away_goals > game.home_goals
      stats_by_team[game.home_team_id][:home_losses] += 1
      stats_by_team[game.home_team_id][:total_losses] += 1
    elsif game.away_goals < game.home_goals
      stats_by_team[game.home_team_id][:home_wins] += 1
      stats_by_team[game.home_team_id][:total_wins] += 1
    end
  end

  def count_of_teams
    stats_by_team.keys.size
  end

  def create_scoring_averages
    stats_by_team.each do |team|
      total_games = team[1][:total_games]
      total_goals = (team[1][:home_goals] + team[1][:away_goals]).to_f
      total_goals_allowed = (team[1][:home_goals_allowed] + team[1][:away_goals_allowed]).to_f
      team[1][:total_scoring_avg] = (total_goals / total_games).round(2)
      team[1][:total_goals_allowed_avg] = (total_goals_allowed / total_games).round(2)
      team[1][:away_scoring_avg] = (team[1][:away_goals] / team[1][:away_games].to_f).round(2)
      team[1][:home_scoring_avg] = (team[1][:home_goals] / team[1][:home_games].to_f).round(2)
    end
  end

  def best_offense
    stats_by_team.max_by { |team_id| team_id[1][:total_scoring_avg]}[1][:team_name]
  end

  def worst_offense
    stats_by_team.min_by { |team_id| team_id[1][:total_scoring_avg]}[1][:team_name]
  end

  def best_defense
    stats_by_team.min_by { |team_id| team_id[1][:total_goals_allowed_avg]}[1][:team_name]
  end

  def worst_defense
    stats_by_team.max_by { |team_id| team_id[1][:total_goals_allowed_avg]}[1][:team_name]
  end

  def highest_scoring_visitor
    stats_by_team.max_by { |team_id| team_id[1][:away_scoring_avg]}[1][:team_name]
  end

  def highest_scoring_home_team
    stats_by_team.max_by { |team_id| team_id[1][:home_scoring_avg]}[1][:team_name]
  end

  def lowest_scoring_visitor
    stats_by_team.min_by { |team_id| team_id[1][:away_scoring_avg]}[1][:team_name]
  end

  def lowest_scoring_home_team
    stats_by_team.min_by { |team_id| team_id[1][:home_scoring_avg]}[1][:team_name]
  end

  def winningest_team
    stats_by_team.max_by do |team_id|
      team_id[1][:total_wins] / team_id[1][:total_games].to_f
    end[1][:team_name]
  end

  def best_fans
    stats_by_team.max_by do |team_id|
      home_win_pct = team_id[1][:home_wins] / team_id[1][:home_games].to_f
      away_win_pct = team_id[1][:away_wins] / team_id[1][:away_games].to_f
      home_win_pct - away_win_pct
    end[1][:team_name]
  end

  def worst_fans
    worst = stats_by_team.find_all do |team_id|
      home_win_pct = team_id[1][:home_wins] / team_id[1][:home_games].to_f
      away_win_pct = team_id[1][:away_wins] / team_id[1][:away_games].to_f
      home_win_pct < away_win_pct
    end
    worst.map { |team| team[1][:team_name] }
  end

end
