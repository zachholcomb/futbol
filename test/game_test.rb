require_relative 'test_helper'
require './lib/game'

class GameTest < Minitest::Test
  def setup
    info = {
            game_id: '2012030221',
            season: '20122013',
            type: 'Postseason',
            date_time: '5/16/13',
            away_team_id: '3',
            home_team_id: '6',
            away_goals: '2',
            home_goals: '3'
          }
    @game1 = Game.new(info)
  end

  def test_it_exists
    assert_instance_of Game, @game1
  end

  def test_it_has_attributes
    assert_equal 2012030221, @game1.game_id
    assert_equal '20122013', @game1.season
    assert_equal 'Postseason', @game1.type
    assert_equal 3, @game1.away_team_id
    assert_equal 6, @game1.home_team_id
    assert_equal 2, @game1.away_goals
    assert_equal 3, @game1.home_goals
  end
end
