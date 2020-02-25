require_relative 'test_helper'
require './lib/game_team_collection'
require './lib/game_team'
require './lib/season_stat_coach'


class SeasonStatCoachTest < Minitest::Test
  def setup
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    @game_team_collection = GameTeamCollection.new(game_team_file_path)
    @season_stat_coach = SeasonStatCoach.new(@game_team_collection)
  end

  def test_it_exists
    assert_instance_of SeasonStatCoach, @season_stat_coach
  end

  def test_it_can_get_game_teams_by_season
    assert_instance_of Array, @season_stat_coach.get_season_game_teams("20122013")
    assert_equal 117, @season_stat_coach.get_season_game_teams("20122013").length
    assert_instance_of GameTeam, @season_stat_coach.get_season_game_teams("20122013").first
  end

  def test_it_can_get_coaches_by_season
    assert_instance_of Array, @season_stat_coach.coaches_by_season("20122013")
    assert_equal "John Tortorella", @season_stat_coach.coaches_by_season("20122013")[0]
    assert_equal "Claude Julien", @season_stat_coach.coaches_by_season("20122013")[1]
    assert_equal "Dan Bylsma", @season_stat_coach.coaches_by_season("20122013")[2]
    assert_equal "Mike Babcock", @season_stat_coach.coaches_by_season("20122013")[3]
    assert_equal "Joel Quenneville", @season_stat_coach.coaches_by_season("20122013")[4]
    assert_equal "Paul MacLean", @season_stat_coach.coaches_by_season("20122013")[5]
    assert_equal "Michel Therrien", @season_stat_coach.coaches_by_season("20122013")[6]
    assert_equal "Mike Yeo", @season_stat_coach.coaches_by_season("20122013")[7]
    assert_equal "Darryl Sutter", @season_stat_coach.coaches_by_season("20122013")[8]
    assert_equal "Ken Hitchcock", @season_stat_coach.coaches_by_season("20122013")[9]
    assert_equal "Bruce Boudreau", @season_stat_coach.coaches_by_season("20122013")[10]
    assert_equal "Jack Capuano", @season_stat_coach.coaches_by_season("20122013")[11]
    assert_equal "Adam Oates", @season_stat_coach.coaches_by_season("20122013")[12]
    assert_equal "Todd Richards", @season_stat_coach.coaches_by_season("20122013")[13]
    assert_equal 14, @season_stat_coach.coaches_by_season("20122013").length
    assert_nil @season_stat_coach.coaches_by_season("20122013")[29]
  end

  def test_it_can_get_coach_wins_by_season
    assert_equal 2, @season_stat_coach.get_coach_wins_by_season("John Tortorella", "20122013")
    assert_equal 9, @season_stat_coach.get_coach_wins_by_season("Claude Julien", "20122013")
    assert_equal 4, @season_stat_coach.get_coach_wins_by_season("Dan Bylsma", "20122013")
    assert_equal 7, @season_stat_coach.get_coach_wins_by_season("Mike Babcock", "20122013")
    assert_equal 9, @season_stat_coach.get_coach_wins_by_season("Joel Quenneville", "20122013")
    assert_equal 3, @season_stat_coach.get_coach_wins_by_season("Paul MacLean", "20122013")
    assert_equal 1, @season_stat_coach.get_coach_wins_by_season("Michel Therrien", "20122013")
    assert_equal 1, @season_stat_coach.get_coach_wins_by_season("Mike Yeo", "20122013")
    assert_equal 5, @season_stat_coach.get_coach_wins_by_season("Darryl Sutter", "20122013")
    assert_equal 3, @season_stat_coach.get_coach_wins_by_season("Ken Hitchcock", "20122013")
    assert_equal 4, @season_stat_coach.get_coach_wins_by_season("Bruce Boudreau", "20122013")
    assert_equal 2, @season_stat_coach.get_coach_wins_by_season("Jack Capuano", "20122013")
    assert_equal 5, @season_stat_coach.get_coach_wins_by_season("Adam Oates", "20122013")
    assert_equal 0, @season_stat_coach.get_coach_wins_by_season("Todd Richards", "20122013")
  end

  def test_it_can_get_all_coach_games_by_season
    assert_equal 12, @season_stat_coach.get_total_coach_games_by_season("John Tortorella", "20122013")
  end

  def test_it_can_get_coach_win_percentage_by_season
    assert_equal 16.67, @season_stat_coach.coach_win_percentage_by_season("John Tortorella", "20122013")
  end

  def test_it_can_create_coaches_hash
    assert_instance_of Hash, @season_stat_coach.create_coach_win_data_by_season("20122013")
    assert_equal 16.67, @season_stat_coach.create_coach_win_data_by_season("20122013")["John Tortorella"]
  end

  def test_it_can_find_winningest_coach
    assert_equal "Claude Julien", @season_stat_coach.winningest_coach("20122013")
  end

  def test_it_can_find_worst_coach
    assert_equal "Todd Richards", @season_stat_coach.worst_coach("20122013")
  end
end
