require 'csv'
require_relative './test_helper'
require './lib/team_stat.rb'
require './lib/game'
require './lib/game_team'
require './lib/team'
require './lib/stat'
require './lib/modules/csv_loadable'

class TeamStatTest < Minitest::Test
  include CSVLoadable

  def setup
    team_file_path = './data/teams.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    game_file_path = './test/fixtures/truncated_games.csv'
    @team_collection = load_csv(team_file_path, Team)
    @game_collection = load_csv(game_file_path, Game)
    @game_team_collection = load_csv(game_team_file_path, GameTeam)
    @stat = Stat.new(@game_collection, @team_collection, @game_team_collection)
    @team_stat = TeamStat.new(@game_collection, @team_collection, @game_team_collection)
  end

  def test_it_exists
    assert_instance_of TeamStat, @team_stat
  end

  def test_it_initializes
    assert_equal 2012020225, @team_stat.game_collection[0].game_id
    assert_equal "Regular Season", @team_stat.game_collection[9].type
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
