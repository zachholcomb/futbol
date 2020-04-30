require_relative 'test_helper'
require './lib/season_stat'
require './lib/game'
require './lib/game_team'
require './lib/team'
require './lib/modules/csv_loadable'

class SeasonStatTest < Minitest::Test
  include CSVLoadable

  def setup
    team_file_path = './data/teams.csv'
    game_file_path = './test/fixtures/truncated_games.csv'
    game_team_file_path = './test/fixtures/truncated_game_teams.csv'
    @team_collection = load_csv(team_file_path, Team)
    @game_collection = load_csv(game_file_path, Game)
    @game_team_collection = load_csv(game_team_file_path, GameTeam)
    @season_stat = SeasonStat.new(@game_collection, @team_collection, @game_team_collection)

    @team_info = {

      1 => {:team_name=> "Apples",
            :season_win_percent => 50.00,
            :postseason_win_percent => 70.00,
            :head_coach => "Jaughn"
          },
      2 => {:team_name=> "The Bunnies",
            :season_win_percent => 80.00,
            :postseason_win_percent => 15.00,
            :head_coach => "Rufus"
          },
      3 => {:team_name=> "Broncos",
            :season_win_percent => 60.00,
            :postseason_win_percent => 70.00,
            :head_coach => "Tim"
          },
      4 => {:team_name=> "Avalanche",
            :season_win_percent => 50.00,
            :postseason_win_percent => 25.00,
            :head_coach => "Aurora"
          },
      5 => {:team_name=> "Avalanche",
            :season_win_percent => 25.00,
            :postseason_win_percent => 0.0,
            :head_coach => "Megan"
            }
    }
    @season = mock('testseason')
  end

  def test_it_exists
    assert_instance_of SeasonStat, @season_stat
  end

  def test_it_can_get_all_seasons
    season_test_list = ["20122013", "20162017", "20142015", "20152016", "20132014"]

    assert_equal season_test_list, @season_stat.get_all_seasons
  end

  def test_it_can_get_season_games
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons
    assert_instance_of Array, @season_stat.get_season_games("20122013")
    assert_equal 257, @season_stat.get_season_games("20122013").length
    assert_equal "20122013", @season_stat.get_season_games("20122013").first.season
  end

  def test_it_can_count_season_games
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    assert_equal 257, @season_stat.count_of_season_games("20122013")
  end
#
  def test_it_can_get_average_goals_by_season
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    test_hash = {
            "20122013"=>4.04,
            "20162017"=>4.75,
            "20142015"=>3.75,
            "20152016"=>3.88,
            "20132014"=>4.33
                }
    assert_equal test_hash, @season_stat.average_goals_by_season
  end

  def test_it_can_get_season_games_by_type
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons
    assert_instance_of Array, @season_stat.games_by_type('Regular Season', "20122013")
    assert_equal 'Regular Season', @season_stat.games_by_type('Regular Season', "20122013").first.type
    assert_instance_of Array, @season_stat.games_by_type('Postseason', "20122013")
    assert_equal 'Postseason', @season_stat.games_by_type('Postseason', "20122013").first.type
    assert_equal [], @season_stat.games_by_type('Overtime', "20122013")
  end

  def test_it_get_team_data_by_team
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    assert_instance_of Hash, @season_stat.get_team_data("20122013")
    assert_equal 32, @season_stat.get_team_data("20122013").length
    assert_equal "1", @season_stat.get_team_data("20122013").keys.first
    assert_equal 'Atlanta United', @season_stat.get_team_data("20122013")["1"][:team_name]
  end

  def test_it_can_get_total_team_games_by_game_type
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    assert_equal 19, @season_stat.total_team_games_by_game_type(29, 'Regular Season', "20122013")
    assert_equal 15, @season_stat.total_team_games_by_game_type(17, 'Regular Season', "20122013")
    assert_equal 14, @season_stat.total_team_games_by_game_type(17, 'Postseason', "20122013")
  end

  def test_it_can_get_total_team_wins_by_game_type
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    assert_equal 4, @season_stat.total_team_wins_by_game_type(29, 'Regular Season', "20122013")
    assert_equal 7, @season_stat.total_team_wins_by_game_type(1, 'Regular Season', "20122013")
    assert_equal 0, @season_stat.total_team_wins_by_game_type(1, 'Postseason', "20122013")
    assert_equal 9, @season_stat.total_team_wins_by_game_type(17, 'Regular Season', "20122013")
    assert_equal 7, @season_stat.total_team_wins_by_game_type(17, 'Postseason', "20122013")
  end

  def test_it_can_calculate_team_win_percentage
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    assert_equal 21.05, @season_stat.team_win_percentage(29, 'Regular Season', "20122013")
    assert_equal 50.00, @season_stat.team_win_percentage(17, 'Postseason', "20122013")
    assert_equal 60.00, @season_stat.team_win_percentage(17, 'Regular Season', "20122013")
  end

  def test_it_can_calculate_biggest_bust
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    @season_stat.stubs(:get_team_data).returns(@team_info)
    assert_equal "The Bunnies", @season_stat.biggest_bust(@season)
  end

  def test_it_can_count_games_by_season
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    test_hash = {
      "20122013" => 257,
      "20162017" => 4,
      "20142015" => 16,
      "20152016" => 16,
      "20132014" => 6
    }
    assert_equal test_hash, @season_stat.count_of_games_by_season
  end

  def test_it_can_calculate_biggest_surprise
    @season_stat.get_all_seasons
    @season_stat.season_games_by_all_seasons

    @season_stat.stubs(:get_team_data).returns(@team_info)
    assert_equal "Apples", @season_stat.biggest_surprise(@season)
  end
#
  def test_it_can_get_coaches_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_instance_of Array, @season_stat.coaches_by_season("20122013")
    assert_equal "John Tortorella", @season_stat.coaches_by_season("20122013")[0]
    assert_equal "Claude Julien", @season_stat.coaches_by_season("20122013")[1]
    assert_equal "Dan Bylsma", @season_stat.coaches_by_season("20122013")[2]
    assert_equal "Mike Babcock", @season_stat.coaches_by_season("20122013")[3]
    assert_equal "Joel Quenneville", @season_stat.coaches_by_season("20122013")[4]
    assert_equal "Paul MacLean", @season_stat.coaches_by_season("20122013")[5]
    assert_equal "Michel Therrien", @season_stat.coaches_by_season("20122013")[6]
    assert_equal "Mike Yeo", @season_stat.coaches_by_season("20122013")[7]
    assert_equal "Darryl Sutter", @season_stat.coaches_by_season("20122013")[8]
    assert_equal "Ken Hitchcock", @season_stat.coaches_by_season("20122013")[9]
    assert_equal "Bruce Boudreau", @season_stat.coaches_by_season("20122013")[10]
    assert_equal "Jack Capuano", @season_stat.coaches_by_season("20122013")[11]
    assert_equal "Adam Oates", @season_stat.coaches_by_season("20122013")[12]
    assert_equal "Todd Richards", @season_stat.coaches_by_season("20122013")[13]
    assert_equal 14, @season_stat.coaches_by_season("20122013").length
    assert_nil @season_stat.coaches_by_season("20122013")[29]
  end

  def test_it_can_get_coach_wins_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_equal 2, @season_stat.get_coach_wins_by_season("John Tortorella", "20122013")
    assert_equal 9, @season_stat.get_coach_wins_by_season("Claude Julien", "20122013")
    assert_equal 4, @season_stat.get_coach_wins_by_season("Dan Bylsma", "20122013")
    assert_equal 7, @season_stat.get_coach_wins_by_season("Mike Babcock", "20122013")
    assert_equal 9, @season_stat.get_coach_wins_by_season("Joel Quenneville", "20122013")
    assert_equal 3, @season_stat.get_coach_wins_by_season("Paul MacLean", "20122013")
    assert_equal 1, @season_stat.get_coach_wins_by_season("Michel Therrien", "20122013")
    assert_equal 1, @season_stat.get_coach_wins_by_season("Mike Yeo", "20122013")
    assert_equal 5, @season_stat.get_coach_wins_by_season("Darryl Sutter", "20122013")
    assert_equal 3, @season_stat.get_coach_wins_by_season("Ken Hitchcock", "20122013")
    assert_equal 4, @season_stat.get_coach_wins_by_season("Bruce Boudreau", "20122013")
    assert_equal 2, @season_stat.get_coach_wins_by_season("Jack Capuano", "20122013")
    assert_equal 5, @season_stat.get_coach_wins_by_season("Adam Oates", "20122013")
    assert_equal 0, @season_stat.get_coach_wins_by_season("Todd Richards", "20122013")
  end

  def test_it_can_get_all_coach_games_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_equal 12, @season_stat.get_total_coach_games_by_season("John Tortorella", "20122013")
  end

  def test_it_can_get_coach_win_percentage_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_equal 16.67, @season_stat.coach_win_percentage_by_season("John Tortorella", "20122013")
  end

  def test_it_can_create_coaches_hash
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_instance_of Hash, @season_stat.create_coach_win_data_by_season("20122013")
    assert_equal 16.67, @season_stat.create_coach_win_data_by_season("20122013")["John Tortorella"]
  end

  def test_it_can_find_winningest_coach
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_equal "Claude Julien", @season_stat.winningest_coach("20122013")
  end

  def test_it_can_find_worst_coach
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_equal "Todd Richards", @season_stat.worst_coach("20122013")
  end

  def test_it_can_get_team_ids_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_instance_of Array, @season_stat.get_team_ids_by_season("20122013")
    assert_equal 14, @season_stat.get_team_ids_by_season("20122013").length
    assert_equal "3", @season_stat.get_team_ids_by_season("20122013")[0]
  end

  def test_it_can_get_team_name_by_team_id
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons

    assert_equal "Houston Dynamo", @season_stat.get_team_name("3")
  end

  def test_it_can_get_team_tackles_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_instance_of Integer, @season_stat.get_tackles_by_team_season("3", "20122013")
    assert_equal 466, @season_stat.get_tackles_by_team_season("3", "20122013")
  end

  def test_it_can_get_team_goals_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal 18, @season_stat.get_goals_by_team_season("3", "20122013")
  end

  def test_it_can_get_team_shots_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal 87, @season_stat.get_shots_by_team_season("3", "20122013")
  end

  def test_it_can_get_goals_to_shots_ratio
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal 4.833, @season_stat.team_shots_to_goal_ratio_by_season("3", "20122013")
  end

  def test_it_can_create_team_data_by_season
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_instance_of Hash, @season_stat.create_team_data_by_season("20122013")
    assert_equal 4.833, @season_stat.create_team_data_by_season("20122013")["3"][:goal_ratio]
    assert_equal "Houston Dynamo", @season_stat.create_team_data_by_season("20122013")["3"][:team_name]
    assert_equal 466, @season_stat.create_team_data_by_season("20122013")["3"][:tackles]
    assert_nil @season_stat.create_team_data_by_season("20122013")["100"]
    assert_equal 14, @season_stat.create_team_data_by_season("20122013").keys.length
  end

  def test_it_can_find_most_accurate_team_name
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal "New York City FC", @season_stat.most_accurate_team("20122013")
  end

  def test_it_can_find_least_accurate_team_name
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal "Houston Dynamo", @season_stat.least_accurate_team("20122013")
  end

  def test_it_can_get_team_with_most_tackles
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal "Houston Dynamo", @season_stat.most_tackles("20122013")
  end

  def test_it_can_find_team_with_least_tackles
    @season_stat.get_all_seasons
    @season_stat.season_game_teams_by_all_seasons
    assert_equal "Orlando Pride", @season_stat.fewest_tackles("20122013")
  end

  def test_it_can_return_team_info
    expected = { "team_id" => "18", "franchise_id" => "34",
                 "team_name" => "Minnesota United FC",
                 "abbreviation" => "MIN",
                 "link" => "/api/v1/teams/18" }

    assert_equal expected, @season_stat.team_info("18")
  end

  def test_it_can_return_best_season
    assert_equal "20142015", @season_stat.best_season("3")
  end

  def test_it_can_return_worst_season
    assert_equal "20122013", @season_stat.worst_season("3")
  end

  def test_it_can_return_total_games_played
    assert_instance_of Hash, @season_stat.total_games_by_season("3")
    assert_equal 12, @season_stat.total_games_by_season("3")["20122013"]
    assert_equal 11, @season_stat.total_games_by_season("3")["20142015"]
    assert_equal 5, @season_stat.total_games_by_season("3")["20152016"]
  end

  def test_it_can_return_winning_game_ids
    assert_instance_of Hash, @season_stat.winning_game_ids("3")
    assert_equal 2, @season_stat.winning_game_ids("3").length
    assert_equal 2, @season_stat.winning_game_ids("3")["20122013"]
    assert_equal 8, @season_stat.winning_game_ids("3")["20142015"]
    assert_equal ["20122013", "20142015"], @season_stat.winning_game_ids("3").keys
  end

  def test_it_can_group_arrays_by_season
    array = ["2012030136", "2012030137", "2014030131", "2014030132", "2014030133", "2014030134", "2014030135", "2014030311", "2014030314", "2014030316"]

    assert_instance_of Hash, @season_stat.group_arrays_by_season(array)

    expected = {"2012"=>["2012030136", "2012030137"],
                "2014"=>["2014030131", "2014030132", "2014030133", "2014030134", "2014030135", "2014030311", "2014030314", "2014030316"]}

    assert_equal expected, @season_stat.group_arrays_by_season(array)
  end

  def test_it_can_transform_key_into_season_and_length
    collection = {"2012"=>["2012030136", "2012030137"],
                  "2014"=>["2014030131", "2014030132", "2014030133", "2014030134", "2014030135", "2014030311", "2014030314", "2014030316"]}

    assert_instance_of Hash, @season_stat.transform_key_into_season(collection)

    expected = {"20122013"=>2, "20142015"=>8}

    assert_equal expected, @season_stat.transform_key_into_season(collection)
  end

  def test_it_can_return_average_wins
    assert_instance_of Hash, @season_stat.average_wins_by_team_per_season("3")
    assert_equal 16.67, @season_stat.average_wins_by_team_per_season("3")["20122013"]
    assert_equal 72.73, @season_stat.average_wins_by_team_per_season("3")["20142015"]
  end

  def test_it_can_return_average_win_percentage
    assert_equal 0.36, @season_stat.average_win_percentage("3")
  end
end
