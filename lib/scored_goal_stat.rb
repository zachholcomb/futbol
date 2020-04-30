require_relative 'stat'
require_relative './modules/helper_methods'

class ScoredGoalStat < Stat
  include Helperable

  def initialize(game_collection, team_collection, game_team_collection)
    super(game_collection, team_collection, game_team_collection)
  end

  def most_goals_scored(team_id)
    total_goals_scored(team_id).max
  end

  def fewest_goals_scored(team_id)
    total_goals_scored(team_id).min
  end

  def total_goals_scored(team_id)
    @game_team_collection.map do |game_team|
      if game_team.team_id.to_s == team_id
        game_team.goals
      end
    end.compact
  end

  def biggest_team_blowout(team_id)
    win_loss_logic(team_id, use_greater = true)
  end

  def worst_loss(team_id)
    win_loss_logic(team_id, use_greater = false)
  end

  def win_loss_logic(team_id, use_greater)
    win_loss = {}
    @game_collection.map do |game|
      if game.away_team_id.to_s == team_id || game.home_team_id.to_s == team_id
        if game.away_team_id.to_s == team_id &&
            ((game.away_goals > game.home_goals && use_greater) ||
                (game.home_goals > game.away_goals && !use_greater))
          win_loss[game.game_id.to_s] = (game.away_goals - game.home_goals).abs
        end
      end
    end
    win_loss.values.max
  end

  def favorite_opponent(team_id)
    min_average_wins = average_opponent_games(team_id, given_team_games_lost(team_id), opponent_games(team_id)).min_by { |opponent_id, average| average }
    get_team_name(min_average_wins.first)
  end

  def rival(team_id)
    max_average_wins = average_opponent_games(team_id, given_team_games_lost(team_id), opponent_games(team_id)).max_by { |opponent_id, average| average }
    get_team_name(max_average_wins.first)
  end

  def opponent_games(team_id)
    create_list_opponent_games(team_id, lost_games = false)
  end

  def given_team_games_lost(team_id)
    create_list_opponent_games(team_id, lost_games = true)
  end

  def create_list_opponent_games(team_id, lost_games)
    @game_collection.reduce({}) do |acc, game|
      if ((game.away_team_id.to_s == team_id && (game.away_goals < game.home_goals)) && lost_games) ||
          (game.away_team_id.to_s == team_id && !lost_games)
        (acc[game.home_team_id.to_s] ||= []) << game.game_id.to_s
      elsif  ((game.home_team_id.to_s == team_id && (game.home_goals < game.away_goals)) && lost_games) ||
          (game.home_team_id.to_s == team_id && !lost_games)
        (acc[game.away_team_id.to_s] ||= []) << game.game_id.to_s
      end
      acc
    end
  end

  def head_to_head(team_id)
    convert_id_to_name(team_id, list_given_team_won_games(team_id), list_opponent_games(team_id))
  end

  def list_opponent_games(team_id)
    create_opponent_game_id_list(team_id, won_games = false)
  end

  def list_given_team_won_games(team_id)
    create_opponent_game_id_list(team_id, won_games = true)
  end

  def create_opponent_game_id_list(team_id, won_games)
    @game_collection.reduce({}) do |acc, game|
      if ((game.away_team_id.to_s == team_id && (game.away_goals > game.home_goals)) && won_games) ||
          (game.away_team_id.to_s == team_id && !won_games)
        (acc[game.home_team_id.to_s] ||= []) << game.game_id.to_s
      elsif  ((game.home_team_id.to_s == team_id && (game.home_goals > game.away_goals)) && won_games) ||
          (game.home_team_id.to_s == team_id && !won_games)
        (acc[game.away_team_id.to_s] ||= []) << game.game_id.to_s
      end
      acc
    end
  end

  def total_opponent_games(team_id, opponents)
    total_games_played = {}
    opponents.map do |opponent_id, game_id|
      total_games_played[opponent_id] = game_id.length
    end
    total_games_played
  end

  def total_given_team_losses(team_id, teams)
    total_games_lost = {}
    teams.map do |opponent_id, game_id|
      total_games_lost[opponent_id] = game_id.length
    end
    total_games_lost
  end

  def average_opponent_games(team_id, teams, opponents)
    total_given_team_losses(team_id, teams).merge(total_opponent_games(team_id, opponents)) do |opponent_id, old, new|
      (old.to_f / new) * 100
    end
  end

  def average_opponent_games_head_to_head(team_id, teams, opponents)
    total_given_team_losses(team_id, teams).merge(total_opponent_games(team_id, opponents)) do |opponent_id, old, new|
      (old.to_f / new).round(2)
    end
  end

  def convert_id_to_name(team_id, teams, opponents)
    new_hash = {}
    average_opponent_games_head_to_head(team_id, teams, opponents).map do |key, value|
      new_hash[get_team_name(key)] = value
    end
    new_hash
  end
end
