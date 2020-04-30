require_relative 'test_helper'
require './lib/scored_goal_stat'
require './lib/game'
require './lib/game_team'
require './lib/team'
require './lib/modules/csv_loadable'

class ScoredGoalStatTest < Minitest::Test
  include CSVLoadable

  def setup
    team_file_path = './data/teams.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    game_file_path = './test/fixtures/truncated_games.csv'
    @team_collection = load_csv(team_file_path, Team)
    @game_collection = load_csv(game_file_path, Game)
    @game_team_collection = load_csv(game_team_file_path, GameTeam)
    @stat = Stat.new(@game_collection, @team_collection, @game_team_collection)
    @scored_goal_stat = ScoredGoalStat.new(@game_collection, @team_collection, @game_team_collection)
  end

  def test_it_exists
    assert_instance_of ScoredGoalStat, @scored_goal_stat
  end

  def test_it_can_return_most_goals_scored
    assert_equal 5, @scored_goal_stat.most_goals_scored("3")
  end

  def test_it_can_return_fewest_goals_scored
    assert_equal 0, @scored_goal_stat.fewest_goals_scored("3")
  end

  def test_it_can_return_total_goals
    assert_instance_of Array, @scored_goal_stat.total_goals_scored("3")
    assert_equal 28, @scored_goal_stat.total_goals_scored("3").length
    assert_equal 2, @scored_goal_stat.total_goals_scored("3").first
  end

  def test_it_can_return_biggest_team_blowout
    assert_equal 4, @scored_goal_stat.biggest_team_blowout("3")
  end

  def test_it_can_return_worst_loss
    assert_equal 3, @scored_goal_stat.worst_loss("3")
  end

  def test_it_can_calculate_win_or_loss
    assert_instance_of Integer, @scored_goal_stat.win_loss_logic("3", true)
    assert_equal 4, @scored_goal_stat.win_loss_logic("3", true)
    assert_equal 3, @scored_goal_stat.win_loss_logic("3", false)
  end

  def test_it_can_return_favorite_opponent
    assert_equal "North Carolina Courage", @scored_goal_stat.favorite_opponent("3")
  end

  def test_it_can_return_rival
    assert_equal "Portland Thorns FC", @scored_goal_stat.rival("3")
  end

  def test_it_can_return_oppoonent_games
    assert_instance_of Hash, @scored_goal_stat.opponent_games("3")
    assert_equal 12, @scored_goal_stat.opponent_games("3").length
    assert_equal ["2012020714", "2012020128"], @scored_goal_stat.opponent_games("3")["1"]
  end

  def test_it_can_return_lost_team_games
    assert_instance_of Hash, @scored_goal_stat.given_team_games_lost("3")
    assert_equal 9, @scored_goal_stat.given_team_games_lost("3").length
    assert_equal ["2014030312", "2014030313", "2014030315"], @scored_goal_stat.given_team_games_lost("3")["14"]
  end

  def test_it_can_create_list_of_opponent_games
    assert_instance_of Hash, @scored_goal_stat.create_list_opponent_games("3", true)
    assert_equal 9, @scored_goal_stat.create_list_opponent_games("3", true).length
    assert_equal ["2014030312", "2014030313", "2014030315"], @scored_goal_stat.create_list_opponent_games("3", true)["14"]
    assert_equal 12, @scored_goal_stat.create_list_opponent_games("3", false).length
    assert_equal ["2012020714", "2012020128"], @scored_goal_stat.create_list_opponent_games("3", false)["1"]
  end

  def test_it_can_return_head_to_head_results
    assert_instance_of Hash, @scored_goal_stat.head_to_head("3")
    assert_equal 12, @scored_goal_stat.head_to_head("3").length
    expected = ["Atlanta United", "Utah Royals FC", "Sporting Kansas City", "Portland Timbers", "DC United", "Portland Thorns FC", "New York City FC", "North Carolina Courage", "New York Red Bulls", "Chicago Fire", "Seattle Sounders FC", "FC Dallas"]
    assert_equal expected, @scored_goal_stat.head_to_head("3").keys
    assert_equal 0.5, @scored_goal_stat.head_to_head("3")["Atlanta United"]
  end

  def test_it_can_list_opponent_games
    assert_instance_of Hash, @scored_goal_stat.list_opponent_games("3")
    assert_equal 12, @scored_goal_stat.list_opponent_games("3").length
    assert_equal ["2012020495"], @scored_goal_stat.list_opponent_games("3")["9"]
  end

  def test_it_can_list_won_team_games
    assert_instance_of Hash, @scored_goal_stat.list_given_team_won_games("3")
    assert_equal 5, @scored_goal_stat.list_given_team_won_games("3").length
    assert_equal ["2012020655"], @scored_goal_stat.list_given_team_won_games("3")["7"]
  end

  def test_it_can_creat_list_of_opponent_game_id
    assert_instance_of Hash, @scored_goal_stat.create_opponent_game_id_list("3", true)
    assert_equal 5, @scored_goal_stat.create_opponent_game_id_list("3", true).length
    assert_equal ["2012030136", "2012030137"], @scored_goal_stat.create_opponent_game_id_list("3", true)["15"]
    assert_equal 12, @scored_goal_stat.create_opponent_game_id_list("3", false).length
    assert_equal ["2012020714", "2012020128"], @scored_goal_stat.create_opponent_game_id_list("3", false)["1"]
  end

  def test_it_can_return_total_opponent_games
    opponents = {"52"=>["2012020396"], "9"=>["2012020495"], "1"=>["2012020714", "2012020128"],
                 "10"=>["2012020592"], "7"=>["2012020655", "2012020317"], "8"=>["2012020512"]}

    assert_instance_of Hash, @scored_goal_stat.total_opponent_games("3", opponents)
    assert_equal [1, 1, 2, 1, 2, 1], @scored_goal_stat.total_opponent_games("3", opponents).values
    assert_equal 1, @scored_goal_stat.total_opponent_games("3", opponents)["8"]
    assert_equal 2, @scored_goal_stat.total_opponent_games("3", opponents)["7"]
  end

  def test_it_can_return_total_team_losses
    teams =  {"1"=>["2012020714"], "7"=>["2012020655"],
              "5"=>["2012020538", "2014030131", "2014030132", "2014030133", "2014030134", "2014030135"],
              "15"=>["2012030136", "2012030137"], "14"=>["2014030311", "2014030314"]}

    assert_instance_of Hash, @scored_goal_stat.total_given_team_losses("3", teams)
    assert_equal 5, @scored_goal_stat.total_given_team_losses("3", teams).length
    assert_equal ["1", "7", "5", "15", "14"], @scored_goal_stat.total_given_team_losses("3", teams).keys
    assert_equal 2, @scored_goal_stat.total_given_team_losses("3", teams)["14"]
    assert_equal 6, @scored_goal_stat.total_given_team_losses("3", teams)["5"]
  end

  def test_it_can_return_average_opponent_games
    teams =  {"1"=>["2012020714"], "7"=>["2012020655"],
              "5"=>["2012020538", "2014030131", "2014030132", "2014030133", "2014030134", "2014030135"],
              "15"=>["2012030136", "2012030137"], "14"=>["2014030311", "2014030314"]}
    opponents = {"52"=>["2012020396"], "9"=>["2012020495"], "1"=>["2012020714", "2012020128"],
                 "10"=>["2012020592"], "7"=>["2012020655", "2012020317"], "8"=>["2012020512"]}

    assert_instance_of Hash, @scored_goal_stat.average_opponent_games("3", teams, opponents)
    assert_equal 2, @scored_goal_stat.average_opponent_games("3", teams, opponents)["15"]
    assert_equal 1, @scored_goal_stat.average_opponent_games("3", teams, opponents)["8"]
  end

  def test_it_can_return_head_to_head_average
    teams =  {"1"=>["2012020714"], "7"=>["2012020655"],
              "5"=>["2012020538", "2014030131", "2014030132", "2014030133", "2014030134", "2014030135"],
              "15"=>["2012030136", "2012030137"], "14"=>["2014030311", "2014030314"]}
    opponents = {"52"=>["2012020396"], "9"=>["2012020495"], "1"=>["2012020714", "2012020128"],
                 "10"=>["2012020592"], "7"=>["2012020655", "2012020317"], "8"=>["2012020512"]}
    assert_instance_of Hash, @scored_goal_stat.average_opponent_games_head_to_head("3", teams, opponents)

    expected = {"1"=>0.5, "7"=>0.5, "5"=>6, "15"=>2, "14"=>2, "52"=>1, "9"=>1, "10"=>1, "8"=>1}

    assert_equal expected, @scored_goal_stat.average_opponent_games_head_to_head("3", teams, opponents)
    assert_equal 9, @scored_goal_stat.average_opponent_games_head_to_head("3", teams, opponents).length
    assert_equal 2, @scored_goal_stat.average_opponent_games_head_to_head("3", teams, opponents)["14"]
  end

  def test_it_can_convert_id_to_name
    teams =  {"1"=>["2012020714"], "7"=>["2012020655"],
              "5"=>["2012020538", "2014030131", "2014030132", "2014030133", "2014030134", "2014030135"],
              "15"=>["2012030136", "2012030137"], "14"=>["2014030311", "2014030314"]}
    opponents = {"52"=>["2012020396"], "9"=>["2012020495"], "1"=>["2012020714", "2012020128"],
                 "10"=>["2012020592"], "7"=>["2012020655", "2012020317"], "8"=>["2012020512"]}

    assert_instance_of Hash, @scored_goal_stat.convert_id_to_name("3", teams, opponents)
    assert_equal 6, @scored_goal_stat.convert_id_to_name("3", teams, opponents)["Sporting Kansas City"]
    assert_equal 9, @scored_goal_stat.convert_id_to_name("3", teams, opponents).length
  end

  def test_it_can_retrieve_team_name
    assert_instance_of String, @scored_goal_stat.get_team_name("3")
    assert_equal "Houston Dynamo", @scored_goal_stat.get_team_name("3")
    assert_equal "New York Red Bulls", @scored_goal_stat.get_team_name("8")
  end
end
