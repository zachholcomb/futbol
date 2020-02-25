require_relative 'test_helper'
require './lib/team_collection'
require './lib/team'

class TeamCollectionTest < Minitest::Test
  def setup
    @file_path = './data/teams.csv'
    @team_collection = TeamCollection.new(@file_path)
  end

  def test_it_exists
    assert_instance_of TeamCollection, @team_collection
  end

  def test_it_can_create_teams_from_csv
    assert_instance_of Array, @team_collection.create_teams(@file_path)
    assert_instance_of Team, @team_collection.create_teams(@file_path).first
  end

  def test_it_has_list_of_teams
    assert_instance_of Array, @team_collection.teams_list
    assert_instance_of Team, @team_collection.teams_list.first
    assert_equal 32, @team_collection.teams_list.length
  end

end
