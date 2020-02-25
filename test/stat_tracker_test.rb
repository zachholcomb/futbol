require_relative 'test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
                }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_instance_of GameTeamCollection, @stat_tracker.game_team_collection
    assert_instance_of TeamCollection, @stat_tracker.team_collection
    assert_instance_of GameCollection, @stat_tracker.game_collection
  end

  def test_it_can_return_team_info

    expected = { "team_id" => "18", "franchise_id" => "34",
                 "team_name" => "Minnesota United FC",
                 "abbreviation" => "MIN",
                 "link" => "/api/v1/teams/18" }

    assert_equal expected, @stat_tracker.team_info("18")
  end

  def test_it_can_return_best_season
    assert_equal "20142015", @stat_tracker.best_season("3")
  end

  def test_it_can_return_worst_season
    assert_equal "20172018", @stat_tracker.worst_season("3")
  end

  def test_it_can_return_average_win_percentage
    assert_equal 0.43, @stat_tracker.average_win_percentage("3")
  end

  def test_it_can_return_most_goals_scored
    assert_equal 6, @stat_tracker.most_goals_scored("3")
  end

  def test_it_can_return_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("3")
  end

  def test_it_can_return_biggest_team_blowout
    assert_equal 4, @stat_tracker.biggest_team_blowout("3")
  end

  def test_it_can_return_worst_loss
    assert_equal 5, @stat_tracker.worst_loss("3")
  end

  def test_it_can_return_favorite_opponent
    assert_equal "Montreal Impact", @stat_tracker.favorite_opponent("3")
  end

  def test_it_can_return_rival
    assert_equal "San Jose Earthquakes", @stat_tracker.rival("3")
  end

  def test_it_can_count_season_games
    expected = {
   "20122013"=>806,
   "20162017"=>1317,
   "20142015"=>1319,
   "20152016"=>1321,
   "20132014"=>1323,
   "20172018"=>1355
    }
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_can_calculate_average_goals_per_game
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_it_can_get_average_goals_by_season
    expected = {
  "20122013"=>4.12,
  "20162017"=>4.23,
  "20142015"=>4.14,
  "20152016"=>4.16,
  "20132014"=>4.19,
  "20172018"=>4.44
    }
    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_it_can_get_biggest_bust
    assert_equal "Montreal Impact", @stat_tracker.biggest_bust("20132014")
    assert_equal "Sporting Kansas City", @stat_tracker.biggest_bust("20142015")
  end

  def test_it_can_get_biggest_surprise
    assert_equal "FC Cincinnati", @stat_tracker.biggest_surprise("20132014")
    assert_equal "Minnesota United FC", @stat_tracker.biggest_surprise("20142015")
  end

  def test_it_can_find_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20132014")
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach("20142015")
  end

  def test_it_can_find_worst_coach
    assert_equal "Peter Laviolette", @stat_tracker.worst_coach("20132014")
    assert_equal "Ted Nolan", @stat_tracker.worst_coach("20142015")
  end

  def test_it_can_find_most_accurate_team_name
    assert_equal "Real Salt Lake", @stat_tracker.most_accurate_team("20132014")
    assert_equal "Toronto FC", @stat_tracker.most_accurate_team("20142015")
  end

  def test_it_can_find_least_accurate_team_name
    assert_equal "New York City FC", @stat_tracker.least_accurate_team("20132014")
    assert_equal "Columbus Crew SC", @stat_tracker.least_accurate_team("20142015")
  end

  def test_it_can_find_team_with_most_tackles
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles("20132014")
    assert_equal "Seattle Sounders FC", @stat_tracker.most_tackles("20142015")
  end

  def test_it_can_find_team_with_fewest_tackles
    assert_equal "Atlanta United", @stat_tracker.fewest_tackles("20132014")
    assert_equal "Orlando City SC", @stat_tracker.fewest_tackles("20142015")
  end

  def test_it_returns_home_win_pct
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_it_returns_away_win_pct
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_it_returns_tie_pct
    assert_equal 0.2, @stat_tracker.percentage_ties
  end
end
