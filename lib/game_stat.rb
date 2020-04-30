require 'csv'
require_relative 'game'

class GameStat < Stat
  attr_reader :pct_data

  def initialize(game_collection, team_collection, game_team_collection)
    super(game_collection, team_collection, game_team_collection)
  end

  def average_goals_per_game
    total = 0
    @game_collection.each do |game|

      total += (game.home_goals + game.away_goals)
    end
    (total.to_f / @pct_data[:total_games]).round(2)
  end

  def pct_of_total_games(outcome_type)
    (@pct_data[outcome_type] / @pct_data[:total_games].to_f).round(2)
  end

  def percentage_home_wins
    pct_of_total_games(:home_wins)
  end

  def percentage_visitor_wins
    pct_of_total_games(:away_wins)
  end

  def percentage_ties
    pct_of_total_games(:ties)
  end
end
