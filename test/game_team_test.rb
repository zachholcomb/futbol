require_relative 'test_helper'
require './lib/game_team'

class GameTeamTest < Minitest::Test

  def setup
    @game = {
      game_id: "2012030221",
      team_id: "3",
      home_away: "away",
      result: "LOSS",
      settled_in: "OT",
      head_coach: "John Tortorella",
      goals: "2",
      shots: "8",
      tackles: "44"
    }
    @game_team3 = GameTeam.new(@game)
  end

  def test_it_exists
    assert_instance_of GameTeam, @game_team3
  end

  def test_it_returns_details
    assert_equal "2012030221", @game_team3.game_id
    assert_equal 3, @game_team3.team_id
    assert_equal "away", @game_team3.home_away
    assert_equal "LOSS", @game_team3.result
    assert_equal "OT", @game_team3.settled_in
    assert_equal "John Tortorella", @game_team3.head_coach
    assert_equal 2, @game_team3.goals
    assert_equal 8, @game_team3.shots
    assert_equal 44, @game_team3.tackles
  end
end
