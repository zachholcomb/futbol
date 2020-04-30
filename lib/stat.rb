class Stat
  attr_reader :games_by_season, :game_teams_by_season, :season_list
  def initialize(game_collection, team_collection, game_team_collection)
    @game_collection = game_collection
    @team_collection = team_collection
    @game_team_collection = game_team_collection
    @season_list = []
    @games_by_season = {}
    @game_teams_by_season = {}
    @stats_by_team = Hash.new do |hash, key|
      hash[key] = Hash.new { |hash, key| hash[key] = 0 }
    end
    create_data
  end

  def create_data
    get_all_seasons
    season_games_by_all_seasons
    season_game_teams_by_all_seasons
    create_teams
    create_league_stats
    create_scoring_averages
  end
  
  def create_teams
    @team_collection.each do |team|
      @stats_by_team[team.team_id][:team_name] = team.team_name
    end
  end

  def create_league_stats
    @game_collection.each do |game|
      game_stats_away(game)
      game_stats_home(game)
    end
  end

  def game_stats_away(game)
    @stats_by_team[game.away_team_id][:away_goals] += game.away_goals
    @stats_by_team[game.away_team_id][:away_goals_allowed] += game.home_goals
    @stats_by_team[game.away_team_id][:total_games] += 1
    @stats_by_team[game.away_team_id][:away_games] += 1
    if game.away_goals > game.home_goals
      @stats_by_team[game.away_team_id][:away_wins] += 1
      @stats_by_team[game.away_team_id][:total_wins] += 1
    elsif game.away_goals < game.home_goals
      @stats_by_team[game.away_team_id][:away_losses] += 1
      @stats_by_team[game.away_team_id][:total_losses] += 1
    end
  end

  def game_stats_home(game)
    @stats_by_team[game.home_team_id][:home_goals] += game.home_goals
    @stats_by_team[game.home_team_id][:home_goals_allowed] += game.away_goals
    @stats_by_team[game.home_team_id][:total_games] += 1
    @stats_by_team[game.home_team_id][:home_games] += 1
    if game.away_goals > game.home_goals
      @stats_by_team[game.home_team_id][:home_losses] += 1
      @stats_by_team[game.home_team_id][:total_losses] += 1
    elsif game.away_goals < game.home_goals
      @stats_by_team[game.home_team_id][:home_wins] += 1
      @stats_by_team[game.home_team_id][:total_wins] += 1
    end
  end

  def create_scoring_averages
    @stats_by_team.each do |team|
      total_games = team[1][:total_games]
      total_goals = (team[1][:home_goals] + team[1][:away_goals]).to_f
      total_goals_allowed = (team[1][:home_goals_allowed] + team[1][:away_goals_allowed]).to_f
      team[1][:total_scoring_avg] = (total_goals / total_games).round(2)
      team[1][:total_goals_allowed_avg] = (total_goals_allowed / total_games).round(2)
      team[1][:away_scoring_avg] = (team[1][:away_goals] / team[1][:away_games].to_f).round(2)
      team[1][:home_scoring_avg] = (team[1][:home_goals] / team[1][:home_games].to_f).round(2)
    end
  end

  def get_all_seasons
    @season_list = @game_collection.map { |game| game.season }.uniq
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
    @game_collection.find_all do |game|
      game.season == season
    end
  end

  def get_season_game_teams(season)
    @game_team_collection.find_all do |game_team|
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
