require 'csv'
require_relative './test_helper'
require './lib/team_stat.rb'
require './lib/game_collection.rb'

class TeamStatTest < Minitest::Test

  def setup
    team_games = "./test/fixtures/truncated_games.csv"
    @game = TeamStat.new(team_games)
  end

  def test_it_exists
    assert_instance_of TeamStat, @game
  end

  def test_it_initializes
    assert_equal 2012020225, @game.game_collection.games_list[0].game_id
    assert_equal "Regular Season", @game.game_collection.games_list[9].type
  end

  def test_highest_total_score
    assert_equal 8, @game.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 0, @game.lowest_total_score
  end

  def test_biggest_blowout
    assert_equal 4, @game.biggest_blowout
  end

end
