require_relative 'test_helper'
require './lib/game_collection'
require './lib/game_team_collection'
require './lib/game_team'
require './lib/team'
require './lib/team_collection'
require './lib/season_stat_team'

class SeasonStatTeamTest < Minitest::Test
  def setup
    team_file_path = './data/teams.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    @team_collection = TeamCollection.new(team_file_path)
    @game_team_collection = GameTeamCollection.new(game_team_file_path)
    @season_stat_team = SeasonStatTeam.new(@game_team_collection, @team_collection)
  end

  def test_it_exists
    assert_instance_of SeasonStatTeam, @season_stat_team
  end

  def test_it_can_get_game_teams_by_season
    assert_instance_of Array, @season_stat_team.get_season_game_teams("20122013")
    assert_equal 117, @season_stat_team.get_season_game_teams("20122013").length
    assert_instance_of GameTeam, @season_stat_team.get_season_game_teams("20122013").first
  end

  def test_it_can_get_team_ids_by_season
    assert_instance_of Array, @season_stat_team.get_team_ids_by_season("20122013")
    assert_equal 14, @season_stat_team.get_team_ids_by_season("20122013").length
    assert_equal 3, @season_stat_team.get_team_ids_by_season("20122013")[0]
  end

  def test_it_can_get_team_name_by_team_id
    assert_equal "Houston Dynamo", @season_stat_team.get_team_name(3)
  end

  def test_it_can_get_team_tackles_by_season
    assert_instance_of Integer, @season_stat_team.get_tackles_by_team_season("3", "20122013")
    assert_equal 466, @season_stat_team.get_tackles_by_team_season("3", "20122013")
  end

  def test_it_can_get_team_goals_by_season
    assert_equal 18, @season_stat_team.get_goals_by_team_season("3", "20122013")
  end

  def test_it_can_get_team_shots_by_season
    assert_equal 87, @season_stat_team.get_shots_by_team_season("3", "20122013")
  end

  def test_it_can_get_goals_to_shots_ratio
    assert_equal 4.833, @season_stat_team.team_shots_to_goal_ratio_by_season("3", "20122013")
  end

  def test_it_can_create_team_data_by_season
    assert_instance_of Hash, @season_stat_team.create_team_data_by_season("20122013")
    assert_equal 4.833, @season_stat_team.create_team_data_by_season("20122013")["3"][:goal_ratio]
    assert_equal "Houston Dynamo", @season_stat_team.create_team_data_by_season("20122013")["3"][:team_name]
    assert_equal 466, @season_stat_team.create_team_data_by_season("20122013")["3"][:tackles]
    assert_nil @season_stat_team.create_team_data_by_season("20122013")["100"]
    assert_equal 14, @season_stat_team.create_team_data_by_season("20122013").keys.length
  end

  def test_it_can_find_most_accurate_team_name
    assert_equal "New York City FC", @season_stat_team.most_accurate_team("20122013")
  end

  def test_it_can_find_least_accurate_team_name
    assert_equal "Houston Dynamo", @season_stat_team.least_accurate_team("20122013")
  end

  def test_it_can_get_team_with_most_tackles
    assert_equal "Houston Dynamo", @season_stat_team.most_tackles("20122013")
  end

  def test_it_can_find_team_with_least_tackles
    assert_equal "Orlando Pride", @season_stat_team.fewest_tackles("20122013")
  end
end
