require_relative 'test_helper'
require './lib/season_win'

class SeasonWinTest < Minitest::Test

  def setup
    team_file_path = './data/teams.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    @team_collection = TeamCollection.new(team_file_path)
    @game_team_collection = GameTeamCollection.new(game_team_file_path)
    @season_win = SeasonWin.new(@team_collection, @game_team_collection)
  end

  def test_it_exists
    assert_instance_of SeasonWin, @season_win
  end

  def test_it_can_return_team_info
    expected = { "team_id" => "18", "franchise_id" => "34",
                 "team_name" => "Minnesota United FC",
                 "abbreviation" => "MIN",
                 "link" => "/api/v1/teams/18" }

    assert_equal expected, @season_win.team_info("18")
  end

  def test_it_can_return_best_season
    assert_equal "20142015", @season_win.best_season("3")
  end

  def test_it_can_return_worst_season
    assert_equal "20122013", @season_win.worst_season("3")
  end

  def test_it_can_return_total_games_played
    assert_instance_of Hash, @season_win.total_games_by_season("3")
    assert_equal 12, @season_win.total_games_by_season("3")["20122013"]
    assert_equal 11, @season_win.total_games_by_season("3")["20142015"]
    assert_equal 5, @season_win.total_games_by_season("3")["20152016"]
  end

  def test_it_can_return_winning_game_ids
    assert_instance_of Hash, @season_win.winning_game_ids("3")
    assert_equal 2, @season_win.winning_game_ids("3").length
    assert_equal 2, @season_win.winning_game_ids("3")["20122013"]
    assert_equal 8, @season_win.winning_game_ids("3")["20142015"]
    assert_equal ["20122013", "20142015"], @season_win.winning_game_ids("3").keys
  end

  def test_it_can_group_arrays_by_season
    array = ["2012030136", "2012030137", "2014030131", "2014030132", "2014030133", "2014030134", "2014030135", "2014030311", "2014030314", "2014030316"]

    assert_instance_of Hash, @season_win.group_arrays_by_season(array)

    expected = {"2012"=>["2012030136", "2012030137"],
                "2014"=>["2014030131", "2014030132", "2014030133", "2014030134", "2014030135", "2014030311", "2014030314", "2014030316"]}

    assert_equal expected, @season_win.group_arrays_by_season(array)
  end

  def test_it_can_transform_key_into_season_and_length
    collection = {"2012"=>["2012030136", "2012030137"],
                  "2014"=>["2014030131", "2014030132", "2014030133", "2014030134", "2014030135", "2014030311", "2014030314", "2014030316"]}

    assert_instance_of Hash, @season_win.transform_key_into_season(collection)

    expected = {"20122013"=>2, "20142015"=>8}

    assert_equal expected, @season_win.transform_key_into_season(collection)
  end

  def test_it_can_return_average_wins
    assert_instance_of Hash, @season_win.average_wins_by_team_per_season("3")
    assert_equal 16.67, @season_win.average_wins_by_team_per_season("3")["20122013"]
    assert_equal 72.73, @season_win.average_wins_by_team_per_season("3")["20142015"]
  end

  def test_it_can_return_average_win_percentage
    assert_equal 0.36, @season_win.average_win_percentage("3")
  end
end
