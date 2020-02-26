require_relative 'test_helper'
require './lib/game_collection'
require './lib/game'

class GameCollectionClass < Minitest::Test
  def setup
    file_path = './test/fixtures/truncated_games.csv'
    @game_collection = GameCollection.new(file_path)
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end

  def test_it_has_list_of_games
    assert_instance_of Array, @game_collection.games_list
    assert_instance_of Game, @game_collection.games_list.first
    assert_equal 299, @game_collection.games_list.length
  end

  def test_it_creates_pct_data
    expected = {
      total_games: 299,
      home_wins: 149,
      away_wins: 103,
      ties: 47
    }
    assert_equal expected, @game_collection.create_pct_data
  end

  def test_it_returns_home_win_pct
    @game_collection.create_pct_data
    assert_equal 0.5, @game_collection.percentage_home_wins
  end

  def test_it_returns_away_win_pct
    @game_collection.create_pct_data
    assert_equal 0.34, @game_collection.percentage_visitor_wins
  end

  def test_it_returns_tie_pct
    @game_collection.create_pct_data
    assert_equal 0.16, @game_collection.percentage_ties
  end

  def test_it_can_calculate_average_goals_per_game
    @game_collection.create_pct_data
    assert_equal 4.03, @game_collection.average_goals_per_game
  end

end
