require 'csv'
require_relative 'game'

class GameStat < Stat
  attr_reader :pct_data

  def initialize(game_collection, team_collection, game_team_collection)
    super(game_collection, team_collection, game_team_collection)
    @pct_data = Hash.new { |hash, key| hash[key] = 0 }
    create_pct_data
  end

  def create_pct_data
    @game_collection.each do |game|
      @pct_data[:total_games] += 1
      if game.home_goals == game.away_goals
        @pct_data[:ties] += 1
      elsif game.home_goals > game.away_goals
        @pct_data[:home_wins] += 1
      else
        @pct_data[:away_wins] += 1
      end
    end
    @pct_data
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
