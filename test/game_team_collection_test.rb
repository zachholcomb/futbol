require_relative 'test_helper'
require './lib/game_team_collection'
require './lib/game_team'

class GameTeamCollectionTest < Minitest::Test
  def setup
    file_path = './test/fixtures/truncated_game_teams.csv'
    @game_team_collection = GameTeamCollection.new(file_path)
  end

  def test_it_exists
    assert_instance_of GameTeamCollection, @game_team_collection
  end

  def test_it_has_list_of_game_teams
    assert_instance_of Array, @game_team_collection.game_team_list
    assert_instance_of GameTeam, @game_team_collection.game_team_list.first
    assert_equal 217, @game_team_collection.game_team_list.length
  end
end
