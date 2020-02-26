require 'csv'
require_relative 'season_win'
require_relative 'season_stat'
require_relative 'scored_goal_stat'
require_relative 'league_stat'
require_relative 'team_stat'
require_relative 'game_collection'

class StatTracker
  attr_reader :game_collection, :team_collection, :game_team_collection

  def initialize(games_file, teams_file, game_teams_file)
    @game_collection = GameCollection.new(games_file)
    @game_team_collection = GameTeamCollection.new(game_teams_file)
    @team_collection = TeamCollection.new(teams_file)
    @season_win = SeasonWin.new(@team_collection, @game_team_collection)
    @scored_goal_stat = ScoredGoalStat.new(@team_collection, @game_team_collection, @game_collection)
    @season = SeasonStat.new(@game_collection, @team_collection, @game_team_collection)
    @season.get_all_seasons
    @season.season_games_by_all_seasons
    @season.season_game_teams_by_all_seasons
    @league_stat = LeagueStat.new(@team_collection, @game_collection)
    @team_stat = TeamStat.new(@games_file)
  end

  def self.from_csv(locations_params)
    games_file = locations_params[:games]
    teams_file = locations_params[:teams]
    game_teams_file = locations_params[:game_teams]

    StatTracker.new(games_file, teams_file, game_teams_file)
  end

  def team_info(team_id)
    @season_win.team_info(team_id)
  end

  def best_season(team_id)
    @season_win.best_season(team_id)
  end

  def worst_season(team_id)
    @season_win.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @season_win.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @scored_goal_stat.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @scored_goal_stat.fewest_goals_scored(team_id)
  end

  def biggest_team_blowout(team_id)
    @scored_goal_stat.biggest_team_blowout(team_id)
  end

  def worst_loss(team_id)
    @scored_goal_stat.worst_loss(team_id)
  end

  def favorite_opponent(team_id)
    @scored_goal_stat.favorite_opponent(team_id)
  end

  def rival(team_id)
    @scored_goal_stat.rival(team_id)
  end

  def head_to_head(team_id)
    @scored_goal_stat.head_to_head(team_id)
  end

  def count_of_games_by_season
    @season.count_of_games_by_season
  end

  def average_goals_per_game
    @game_collection.average_goals_per_game
  end

  def average_goals_by_season
    @season.average_goals_by_season
  end

  def biggest_bust(season_param)
    @season.biggest_bust(season_param)
  end

  def biggest_surprise(season_param)
    @season.biggest_surprise(season_param)
  end

  def winningest_coach(season_param)
    @season.winningest_coach(season_param)
  end

  def worst_coach(season_param)
    @season.worst_coach(season_param)
  end

  def most_accurate_team(season_param)
    @season.most_accurate_team(season_param)
  end

  def least_accurate_team(season_param)
    @season.least_accurate_team(season_param)
  end

  def most_tackles(season_param)
    @season.most_tackles(season_param)
  end

  def fewest_tackles(season_param)
    @season.fewest_tackles(season_param)
  end

  def count_of_teams
    @league_stat.count_of_teams
  end

  def best_offense
    @league_stat.create_scoring_averages
    @league_stat.best_offense
  end

  def worst_offense
    @league_stat.create_scoring_averages
    @league_stat.worst_offense
  end

  def best_defense
    @league_stat.create_scoring_averages
    @league_stat.best_defense
  end

  def worst_defense
    @league_stat.create_scoring_averages
    @league_stat.worst_defense
  end

  def highest_scoring_visitor
    @league_stat.create_scoring_averages
    @league_stat.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @league_stat.create_scoring_averages
    @league_stat.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @league_stat.create_scoring_averages
    @league_stat.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @league_stat.create_scoring_averages
    @league_stat.lowest_scoring_home_team
  end

  def winningest_team
    @league_stat.create_scoring_averages
    @league_stat.winningest_team
  end

  def best_fans
    @league_stat.create_scoring_averages
    @league_stat.best_fans
  end

  def worst_fans
    @league_stat.create_scoring_averages
    @league_stat.worst_fans
  end

  def percentage_home_wins
    @game_collection.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_collection.percentage_visitor_wins
  end

  def percentage_ties
    @game_collection.percentage_ties
  end

  def highest_total_score

    team_stat.highest_total_score
  end

  def lowest_total_score
    team_stat = TeamStat.new(@games_file)
    team_stat.lowest_total_score
  end

  def biggest_blowout
    team_stat = TeamStat.new(@games_file)
    team_stat.biggest_blowout
  end
end
