require_relative 'test_helper'
require './lib/season_stat'
require './lib/game'
require './lib/game_team'
require './lib/team'
require './lib/stat'
require './lib/modules/csv_loadable'

class StatTest < Minitest::Test
  include CSVLoadable

  def setup
    team_file_path = './data/teams.csv'
    game_file_path = './test/fixtures/truncated_games.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    @team_collection = load_csv(team_file_path, Team)
    @game_collection = load_csv(game_file_path, Game)
    @game_team_collection = load_csv(game_team_file_path, GameTeam)
    @stat = Stat.new(@game_collection, @team_collection, @game_team_collection)
  end

  def test_it_exists
    assert_instance_of Stat, @stat
  end

  def test_it_can_get_all_seasons
    season_test_list = ["20122013", "20162017", "20142015", "20152016", "20132014"]

    assert_equal season_test_list, @stat.get_all_seasons
  end

  def test_it_can_get_season_games
    @stat.get_all_seasons
    @stat.season_games_by_all_seasons

    assert_instance_of Array, @stat.get_season_games("20122013")
    assert_equal 257, @stat.get_season_games("20122013").length
    assert_equal "20122013", @stat.get_season_games("20122013").first.season
  end

  def test_it_can_get_season_game_teams
    @stat.get_all_seasons
    @stat.season_games_by_all_seasons

    assert_instance_of Array, @stat.get_season_game_teams("20122013")
    assert_equal 117, @stat.get_season_game_teams("20122013").length
    assert_equal "John Tortorella", @stat.get_season_game_teams("20122013").first.head_coach
  end

  def test_it_has_attributes
    assert_instance_of Hash, @stat.games_by_season
    assert_instance_of Array, @stat.games_by_season["20122013"]
    assert_equal 257, @stat.games_by_season["20122013"].length
    assert_instance_of Game, @stat.games_by_season["20122013"].first
    assert_instance_of Hash, @stat.game_teams_by_season
    assert_instance_of Array, @stat.game_teams_by_season["20122013"]
    assert_equal 117, @stat.game_teams_by_season["20122013"].length
    assert_instance_of GameTeam, @stat.game_teams_by_season["20122013"].first
    assert_instance_of Array, @stat.season_list
  end

  def test_it_can_get_season_games_by_seasons
    @stat.get_all_seasons
    assert_instance_of Hash, @stat.season_games_by_all_seasons
    assert_equal 257, @stat.season_games_by_all_seasons["20122013"].length
    assert_instance_of Game, @stat.season_games_by_all_seasons["20122013"].first
  end

  def test_it_can_get_all_game_teams_by_season
    @stat.get_all_seasons
    assert_instance_of Hash, @stat.season_game_teams_by_all_seasons
    assert_instance_of GameTeam, @stat.season_game_teams_by_all_seasons["20122013"].first
    assert_equal 117, @stat.season_game_teams_by_all_seasons["20122013"].length
  end

  def test_it_can_get_team_tackles_by_season
    @stat.get_all_seasons
    @stat.season_game_teams_by_all_seasons
    assert_instance_of Integer, @stat.get_tackles_by_team_season("3", "20122013")
    assert_equal 466, @stat.get_tackles_by_team_season("3", "20122013")
  end

  def test_it_can_get_team_goals_by_season
    @stat.get_all_seasons
    @stat.season_game_teams_by_all_seasons
    assert_equal 18, @stat.get_goals_by_team_season("3", "20122013")
  end

  def test_it_can_get_team_shots_by_season
    @stat.get_all_seasons
    @stat.season_game_teams_by_all_seasons
    assert_equal 87, @stat.get_shots_by_team_season("3", "20122013")
  end

  def test_it_can_get_goals_to_shots_ratio
    @stat.get_all_seasons
    @stat.season_game_teams_by_all_seasons
    assert_equal 4.833, @stat.team_shots_to_goal_ratio_by_season("3", "20122013")
  end



  def test_it_can_get_total_team_games_by_game_type
    @stat.get_all_seasons
    @stat.season_games_by_all_seasons

    assert_equal 19, @stat.total_team_games_by_game_type(29, 'Regular Season', "20122013")
    assert_equal 15, @stat.total_team_games_by_game_type(17, 'Regular Season', "20122013")
    assert_equal 14, @stat.total_team_games_by_game_type(17, 'Postseason', "20122013")
  end

  def test_it_can_get_total_team_wins_by_game_type
    @stat.get_all_seasons
    @stat.season_games_by_all_seasons

    assert_equal 4, @stat.total_team_wins_by_game_type(29, 'Regular Season', "20122013")
    assert_equal 7, @stat.total_team_wins_by_game_type(1, 'Regular Season', "20122013")
    assert_equal 0, @stat.total_team_wins_by_game_type(1, 'Postseason', "20122013")
    assert_equal 9, @stat.total_team_wins_by_game_type(17, 'Regular Season', "20122013")
    assert_equal 7, @stat.total_team_wins_by_game_type(17, 'Postseason', "20122013")
  end

  def test_it_can_calculate_team_win_percentage
    @stat.get_all_seasons
    @stat.season_games_by_all_seasons

    assert_equal 21.05, @stat.team_win_percentage(29, 'Regular Season', "20122013")
    assert_equal 50.00, @stat.team_win_percentage(17, 'Postseason', "20122013")
    assert_equal 60.00, @stat.team_win_percentage(17, 'Regular Season', "20122013")
  end

  def test_it_can_get_team_ids_by_season
    @stat.get_all_seasons
    @stat.season_game_teams_by_all_seasons

    assert_instance_of Array, @stat.get_team_ids_by_season("20122013")
    assert_equal 14, @stat.get_team_ids_by_season("20122013").length
    assert_equal "3", @stat.get_team_ids_by_season("20122013")[0]
  end
end
