class LeagueStat

  attr_reader :stats_by_team

  def initialize(teams_list, games_list)
    @team_collection = TeamCollection.new(teams_list)
    @game_collection = GameCollection.new(games_list)
    @stats_by_team = Hash.new do |hash, key|
      hash[key] = Hash.new { |hash, key| hash[key] = 0 }
    end
    create_teams(@team_collection.teams_list)
    create_league_stats(@game_collection.games_list)
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
    if game.away_goals > game.home_goals
      stats_by_team[game.away_team_id][:away_wins] += 1
    elsif game.away_goals < game.home_goals
      stats_by_team[game.away_team_id][:away_losses] += 1
    end
  end

  def game_stats_home(game)
    stats_by_team[game.home_team_id][:home_goals] += game.home_goals
    stats_by_team[game.home_team_id][:home_goals_allowed] += game.away_goals
    stats_by_team[game.home_team_id][:total_games] += 1
    if game.away_goals > game.home_goals
      stats_by_team[game.home_team_id][:home_losses] += 1
    elsif game.away_goals < game.home_goals
      stats_by_team[game.home_team_id][:home_wins] += 1
    end
  end

  def count_of_teams
    stats_by_team.keys.size
  end

  def best_offense
    goals_per_game = {}
    stats_by_team.each do |team|
      total_goals = (team[1][:home_goals] + team[1][:away_goals]).to_f
      goals_per_game[team[1][:team_name]] = (total_goals / team[1][:total_games]).round(2)
    end
    goals_per_game.max_by { |name, goals_per_game| goals_per_game }[0]
  end

  def worst_offense
    goals_per_game = {}
    stats_by_team.each do |team|
      total_goals = (team[1][:home_goals] + team[1][:away_goals]).to_f
      goals_per_game[team[1][:team_name]] = (total_goals / team[1][:total_games]).round(2)
    end
    goals_per_game.min_by { |name, goals_per_game| goals_per_game }[0]
  end

end
