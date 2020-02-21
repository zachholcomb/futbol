require_relative 'test_helper'
require './lib/season_stat'
require './lib/game_collection'
require './lib/game_team_collection'
require './lib/team_collection'
require './lib/game'
require './lib/game_team'
require './lib/team'

class SeasonStatTest < Minitest::Test
  def setup
    team_file_path = './data/teams.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    game_file_path = './test/fixtures/truncated_games.csv'
    @season_stat = SeasonStat.new(game_file_path, team_file_path, game_team_file_path)
  end

  def test_it_exists
    assert_instance_of SeasonStat, @season_stat
  end

  def test_it_can_get_season_games
    assert_instance_of Array, @season_stat.get_season_games("20122013")
    assert_equal 257, @season_stat.get_season_games("20122013").length
    assert_equal "20122013", @season_stat.get_season_games("20122013").first.season
  end

  def test_it_has_attributes
    assert_instance_of Array, @season_stat.get_season_games("20122013")
    assert_equal 257, @season_stat.get_season_games("20122013").length
    assert_instance_of Game, @season_stat.get_season_games("20122013").first
  end

  def test_it_can_count_season_games
    assert_equal 257, @season_stat.count_of_season_games("20122013")
  end

  def test_it_can_get_season_games_by_type
    assert_instance_of Array, @season_stat.games_by_type('Regular Season', "20122013")
    assert_equal 'Regular Season', @season_stat.games_by_type('Regular Season', "20122013").first.type
    assert_instance_of Array, @season_stat.games_by_type('Postseason', "20122013")
    assert_equal 'Postseason', @season_stat.games_by_type('Postseason', "20122013").first.type
    assert_equal [], @season_stat.games_by_type('Overtime', "20122013")
  end

  def test_it_get_team_info_by_team
    assert_instance_of Hash, @season_stat.get_team_info("20122013")
    assert_equal 32, @season_stat.get_team_info("20122013").length
    assert_equal 1, @season_stat.get_team_info("20122013").keys.first
    assert_equal 'Atlanta United', @season_stat.get_team_info("20122013")[1][:team_name]
  end

  def test_it_can_get_total_team_games_by_game_type
    assert_equal 19, @season_stat.total_team_games_by_game_type(29, 'Regular Season', "20122013")
    assert_equal 15, @season_stat.total_team_games_by_game_type(17, 'Regular Season', "20122013")
    assert_equal 14, @season_stat.total_team_games_by_game_type(17, 'Postseason', "20122013")
  end

  def test_it_can_get_total_team_wins_by_game_type
    assert_equal 4, @season_stat.total_team_wins_by_game_type(29, 'Regular Season', "20122013")
    assert_equal 7, @season_stat.total_team_wins_by_game_type(1, 'Regular Season', "20122013")
    assert_equal 0, @season_stat.total_team_wins_by_game_type(1, 'Postseason', "20122013")
    assert_equal 9, @season_stat.total_team_wins_by_game_type(17, 'Regular Season', "20122013")
    assert_equal 7, @season_stat.total_team_wins_by_game_type(17, 'Postseason', "20122013")
  end

  def test_it_can_calculate_team_win_percentage
    assert_equal 21.05, @season_stat.team_win_percentage(29, 'Regular Season', "20122013")
    assert_equal 50.00, @season_stat.team_win_percentage(17, 'Postseason', "20122013")
    assert_equal 60.00, @season_stat.team_win_percentage(17, 'Regular Season', "20122013")
  end

  def test_it_can_calculate_biggest_bust
      skip
    @season_stat.get_team_info
    @season_stat.get_regular_percents('Regular Season')
  end

  def test_it_can_count_games_by_season
    test_hash = {
      "20122013" => 257,
      "20162017" => 4,
      "20142015" => 16,
      "20152016" => 16,
      "20132014" => 6
    }
    assert_equal test_hash, @season_stat.count_of_games_by_season
  end
end