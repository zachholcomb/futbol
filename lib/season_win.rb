require_relative 'team_collection'
require_relative 'game_team_collection'

class SeasonWin

  def initialize(team_collection, game_team_collection)
    @team_collection = team_collection
    @game_team_collection = game_team_collection
  end

  def team_info(team_id)
    @team_collection.teams_list.reduce(Hash.new) do |acc, team|
      if team_id == team.team_id.to_s
        acc = {"team_id" => team.team_id.to_s,
               "franchise_id" => team.franchise_id.to_s,
               "team_name" => team.team_name,
               "abbreviation" => team.abbreviation,
               "link" => team.link}
      end
      acc
    end
  end

  def best_season(team_id)
    max_value = average_wins_by_team_per_season(team_id).max_by do |key, value|
      value
    end
    max_value.first
  end

  def worst_season(team_id)
    min_value = average_wins_by_team_per_season(team_id).min_by do |key, value|
      value
    end
    min_value.first
  end

  def total_games_by_season(team_id)
    create_total_games_by_id(team_id, win_game = false)
  end

  def winning_game_ids(team_id)
    create_total_games_by_id(team_id, win_game = true)
  end

  def create_total_games_by_id(team_id, win_game)
    total_games =  @game_team_collection.game_team_list.map do |game_team|
      if (game_team.team_id.to_s == team_id && (game_team.result == "WIN") && win_game) ||
          (game_team.team_id.to_s == team_id && !win_game)
        game_team.game_id.to_s
      end
    end.compact
    grouped_games = group_arrays_by_season(total_games)
    transform_key_into_season(grouped_games)
  end

  def group_arrays_by_season(game_id_array)
    game_id_array.group_by do |game_id|
      game_id[0..3]
    end
  end

  def transform_key_into_season(team_collection)
    total = {}
    team_collection.map do |key, value|
      total[key + (key.to_i + 1).to_s] = value.length
    end
    total
  end

  def average_wins_by_team_per_season(team_id)
    final_total_won_games = {}
    winning_game_ids(team_id).map do |key, value|
      total_games = total_games_by_season(team_id)[key]
      if total_games != nil
        final_total_won_games[key] = ((value.to_f / total_games) * 100).round(2)
      end
    end
    final_total_won_games
  end

  def average_win_percentage(team_id)
    won_games = winning_game_ids(team_id).values.sum
    total_games = total_games_by_season(team_id).values.sum
    (won_games.to_f / total_games).round(2)
  end
end
