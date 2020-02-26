require 'csv'
require_relative './test_helper'
require './lib/team_stat.rb'

class TeamStatTest < Minitest::Test

  def setup
    game_file_path = "./test/fixtures/truncated_games.csv"
    @game_collection = GameCollection.new(game_file_path)
    @team_stat = TeamStat.new(@game_collection)
  end

  def test_it_exists
    assert_instance_of TeamStat, @team_stat
  end

  def test_it_initializes
    assert_equal 2012020225, @team_stat.game_collection.games_list[0].game_id
    assert_equal "Regular Season", @team_stat.game_collection.games_list[9].type
  end

  def test_highest_total_score
    assert_instance_of Integer, @team_stat.highest_total_score
    assert_equal 8, @team_stat.highest_total_score
  end

  def test_lowest_total_score
    assert_instance_of Integer, @team_stat.lowest_total_score
    assert_equal 0, @team_stat.lowest_total_score
  end

  def test_biggest_blowout
    assert_instance_of Integer, @team_stat.biggest_blowout
    assert_equal 4, @team_stat.biggest_blowout
  end
end
