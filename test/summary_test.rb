# require_relative 'test_helper'
# require './lib/summary'
#
# class SummaryTest < Minitest::Test
#
#   def setup
#     team_file_path = './data/teams.csv'
#     game_team_file_path = './test/fixtures/truncated_game_teams.csv'
#     game_file_path = './test/fixtures/truncated_games.csv'
#     @summary = Summary.new(team_file_path, game_team_file_path, game_file_path)
#   end
#
#   def test_it_exists
#     assert_instance_of Summary, @summary
#   end
#
#   def test_it_can_return_opponent_average_win_hash
#     expected = {"6" => 54.98}
#
#     assert_equal expected, @summary.head_to_head("3")
#   end
#
#   def test_it_can_return_seaosnal_summary
#     expected = {"3523532524" => {:postseason => {:win_percentage => 23.45}}}
#
#     assert_equal expected, @summary.seasonal_summary("3")
#     assert_equal "yes", @summary.split_post_reg_season("3")
#   end
# end