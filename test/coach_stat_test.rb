require_relative 'test_helper'
require './lib/coach_stat'
require './lib/game'
require './lib/game_team'
require './lib/team'
require './lib/modules/csv_loadable'
require './lib/stat'

class CoachStatTest < Minitest::Test
  include CSVLoadable

  def setup
    team_file_path = './data/teams.csv'
    game_file_path = './test/fixtures/truncated_games.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    @team_collection = load_csv(team_file_path, Team)
    @game_collection = load_csv(game_file_path, Game)
    @game_team_collection = load_csv(game_team_file_path, GameTeam)
    @coach_stat = CoachStat.new(@game_collection, @team_collection, @game_team_collection)
  end

  def test_it_can_get_coaches_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_instance_of Array, @coach_stat.coaches_by_season("20122013")
    assert_equal "John Tortorella", @coach_stat.coaches_by_season("20122013")[0]
    assert_equal "Claude Julien", @coach_stat.coaches_by_season("20122013")[1]
    assert_equal "Dan Bylsma", @coach_stat.coaches_by_season("20122013")[2]
    assert_equal "Mike Babcock", @coach_stat.coaches_by_season("20122013")[3]
    assert_equal "Joel Quenneville", @coach_stat.coaches_by_season("20122013")[4]
    assert_equal "Paul MacLean", @coach_stat.coaches_by_season("20122013")[5]
    assert_equal "Michel Therrien", @coach_stat.coaches_by_season("20122013")[6]
    assert_equal "Mike Yeo", @coach_stat.coaches_by_season("20122013")[7]
    assert_equal "Darryl Sutter", @coach_stat.coaches_by_season("20122013")[8]
    assert_equal "Ken Hitchcock", @coach_stat.coaches_by_season("20122013")[9]
    assert_equal "Bruce Boudreau", @coach_stat.coaches_by_season("20122013")[10]
    assert_equal "Jack Capuano", @coach_stat.coaches_by_season("20122013")[11]
    assert_equal "Adam Oates", @coach_stat.coaches_by_season("20122013")[12]
    assert_equal "Todd Richards", @coach_stat.coaches_by_season("20122013")[13]
    assert_equal 14, @coach_stat.coaches_by_season("20122013").length
    assert_nil @coach_stat.coaches_by_season("20122013")[29]
  end

  def test_it_can_get_coach_wins_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal 2, @coach_stat.get_coach_wins_by_season("John Tortorella", "20122013")
    assert_equal 9, @coach_stat.get_coach_wins_by_season("Claude Julien", "20122013")
    assert_equal 4, @coach_stat.get_coach_wins_by_season("Dan Bylsma", "20122013")
    assert_equal 7, @coach_stat.get_coach_wins_by_season("Mike Babcock", "20122013")
    assert_equal 9, @coach_stat.get_coach_wins_by_season("Joel Quenneville", "20122013")
    assert_equal 3, @coach_stat.get_coach_wins_by_season("Paul MacLean", "20122013")
    assert_equal 1, @coach_stat.get_coach_wins_by_season("Michel Therrien", "20122013")
    assert_equal 1, @coach_stat.get_coach_wins_by_season("Mike Yeo", "20122013")
    assert_equal 5, @coach_stat.get_coach_wins_by_season("Darryl Sutter", "20122013")
    assert_equal 3, @coach_stat.get_coach_wins_by_season("Ken Hitchcock", "20122013")
    assert_equal 4, @coach_stat.get_coach_wins_by_season("Bruce Boudreau", "20122013")
    assert_equal 2, @coach_stat.get_coach_wins_by_season("Jack Capuano", "20122013")
    assert_equal 5, @coach_stat.get_coach_wins_by_season("Adam Oates", "20122013")
    assert_equal 0, @coach_stat.get_coach_wins_by_season("Todd Richards", "20122013")
  end

  def test_it_can_get_all_coach_games_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal 12, @coach_stat.get_total_coach_games_by_season("John Tortorella", "20122013")
  end

  def test_it_can_get_coach_win_percentage_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal 16.67, @stat.coach_win_percentage_by_season("John Tortorella", "20122013")
  end

  def test_it_can_get_coaches_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_instance_of Array, @coach_stat.coaches_by_season("20122013")
    assert_equal "John Tortorella", @coach_stat.coaches_by_season("20122013")[0]
    assert_equal "Claude Julien", @coach_stat.coaches_by_season("20122013")[1]
    assert_equal "Dan Bylsma", @coach_stat.coaches_by_season("20122013")[2]
    assert_equal "Mike Babcock", @coach_stat.coaches_by_season("20122013")[3]
    assert_equal "Joel Quenneville", @coach_stat.coaches_by_season("20122013")[4]
    assert_equal "Paul MacLean", @coach_stat.coaches_by_season("20122013")[5]
    assert_equal "Michel Therrien", @coach_stat.coaches_by_season("20122013")[6]
    assert_equal "Mike Yeo", @coach_stat.coaches_by_season("20122013")[7]
    assert_equal "Darryl Sutter", @coach_stat.coaches_by_season("20122013")[8]
    assert_equal "Ken Hitchcock", @coach_stat.coaches_by_season("20122013")[9]
    assert_equal "Bruce Boudreau", @coach_stat.coaches_by_season("20122013")[10]
    assert_equal "Jack Capuano", @coach_stat.coaches_by_season("20122013")[11]
    assert_equal "Adam Oates", @coach_stat.coaches_by_season("20122013")[12]
    assert_equal "Todd Richards", @coach_stat.coaches_by_season("20122013")[13]
    assert_equal 14, @coach_stat.coaches_by_season("20122013").length
    assert_nil @coach_stat.coaches_by_season("20122013")[29]
  end

  def test_it_can_get_coach_wins_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal 2, @coach_stat.get_coach_wins_by_season("John Tortorella", "20122013")
    assert_equal 9, @coach_stat.get_coach_wins_by_season("Claude Julien", "20122013")
    assert_equal 4, @coach_stat.get_coach_wins_by_season("Dan Bylsma", "20122013")
    assert_equal 7, @coach_stat.get_coach_wins_by_season("Mike Babcock", "20122013")
    assert_equal 9, @coach_stat.get_coach_wins_by_season("Joel Quenneville", "20122013")
    assert_equal 3, @coach_stat.get_coach_wins_by_season("Paul MacLean", "20122013")
    assert_equal 1, @coach_stat.get_coach_wins_by_season("Michel Therrien", "20122013")
    assert_equal 1, @coach_stat.get_coach_wins_by_season("Mike Yeo", "20122013")
    assert_equal 5, @coach_stat.get_coach_wins_by_season("Darryl Sutter", "20122013")
    assert_equal 3, @coach_stat.get_coach_wins_by_season("Ken Hitchcock", "20122013")
    assert_equal 4, @coach_stat.get_coach_wins_by_season("Bruce Boudreau", "20122013")
    assert_equal 2, @coach_stat.get_coach_wins_by_season("Jack Capuano", "20122013")
    assert_equal 5, @coach_stat.get_coach_wins_by_season("Adam Oates", "20122013")
    assert_equal 0, @coach_stat.get_coach_wins_by_season("Todd Richards", "20122013")
  end

  def test_it_can_get_all_coach_games_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal 12, @coach_stat.get_total_coach_games_by_season("John Tortorella", "20122013")
  end

  def test_it_can_get_coach_win_percentage_by_season
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal 16.67, @coach_stat.coach_win_percentage_by_season("John Tortorella", "20122013")
  end

  def test_it_can_create_coaches_hash
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_instance_of Hash, @coach_stat.create_coach_win_data_by_season("20122013")
    assert_equal 16.67, @coach_stat.create_coach_win_data_by_season("20122013")["John Tortorella"]
  end

  def test_it_can_find_winningest_coach
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal "Claude Julien", @coach_stat.winningest_coach("20122013")
  end

  def test_it_can_find_worst_coach
    @coach_stat.get_all_seasons
    @coach_stat.season_game_teams_by_all_seasons

    assert_equal "Todd Richards", @coach_stat.worst_coach("20122013")
  end
  
end