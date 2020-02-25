# require_relative 'team_collection'
# require_relative 'game_team_collection'
# require_relative 'game_collection'
#
# class Summary
#
#   def initialize(team_file_path, game_team_file_path, game_file_path)
#     @team_collection = TeamCollection.new(team_file_path)
#     @game_team_collection = GameTeamCollection.new(game_team_file_path)
#     @game_collection = GameCollection.new(game_file_path)
#   end
#
#   def head_to_head(team_id)
#     convert_id_to_name(team_id)
#   end
#
#   def list_opponent_games(team_id)
#     create_opponent_game_id_list(team_id, won_games = false)
#   end
#
#   def list_given_team_won_games(team_id)
#     create_opponent_game_id_list(team_id, won_games = true)
#   end
#
#   def create_opponent_game_id_list(team_id, won_games)
#     @game_collection.games_list.reduce({}) do |acc, game|
#       if ((game.away_team_id.to_s == team_id && (game.away_goals > game.home_goals)) && won_games) ||
#           (game.away_team_id.to_s == team_id && !won_games)
#         (acc[game.home_team_id.to_s] ||= []) << game.game_id.to_s
#       elsif  ((game.home_team_id.to_s == team_id && (game.home_goals > game.away_goals)) && won_games) ||
#           (game.home_team_id.to_s == team_id && !won_games)
#         (acc[game.away_team_id.to_s] ||= []) << game.game_id.to_s
#       end
#       acc
#     end
#   end
#
#   def total_opponent_games(team_id)
#     total_games_played = {}
#     list_opponent_games(team_id).map do |opponent_id, game_id|
#       total_games_played[opponent_id] = game_id.length
#     end
#     total_games_played
#   end
#
#   def total_given_team_wins(team_id)
#     total_games_won = {}
#     list_given_team_won_games(team_id).map do |opponent_id, game_id|
#       total_games_won[opponent_id] = game_id.length
#     end
#     total_games_won
#   end
#
#   def average_won_games(team_id)
#     total_given_team_wins(team_id).merge(total_opponent_games(team_id)) do |opponent_id, old, new|
#       (old.to_f / new).round(2)
#     end
#   end
#
#   def convert_id_to_name(team_id)
#     new_hash = {}
#     average_won_games(team_id).map do |key, value|
#       new_hash[retrieve_team_name(key)] = value
#     end
#     new_hash
#   end
#
#   def retrieve_team_name(team_id)
#     @team_collection.teams_list.map do |team|
#       if team.team_id.to_s == team_id
#         team.team_name
#       end
#     end.compact.first
#   end
#
#   def seasonal_summary(team_id)
#     setup_hash(team_id)
#   end
#
#   def setup_hash(team_id)
#     @game_collection.games_list.reduce({}) do |acc, game|
#       if game.away_team_id.to_s == team_id || game.home_team_id.to_s == team_id
#         acc[game.season] = {:postseason => {:win_percentage => 1,
#                                             :total_goals_scored => 1,
#                                             :total_goals_against => 1,
#                                             :average_goals_scored => 1,
#                                             :average_goals_against => 1},
#                             :regular_season => {:win_percentage => 1,
#                                                 :total_goals_scored => 1,
#                                                 :total_goals_against => 1,
#                                                 :average_goals_scored => 1,
#                                                 :average_goals_against => 1}}
#         end
#       acc
#     end
#   end
#
#
#
#
#
#
#
#
#
#
#   # def goals_split_post_reg_season_away_goals(team_id)
#   #   @game_collection.games_list.reduce({}) do |acc, game|
#   #     if game.away_team_id.to_s == team_id
#   #       (acc[game.type] ||= []) << game.away_goals
#   #     end
#   #     acc
#   #   end
#   # end
#   #
#   # def goals_split_post_reg_season_home_goals(team_id)
#   #   @game_collection.games_list.reduce({}) do |acc, game|
#   #     if game.home_team_id.to_s == team_id
#   #       (acc[game.type] ||= []) << game.home_goals
#   #     end
#   #     acc
#   #   end
#   # end
#   #
#   # def regular_season_away_goals(team_id)
#   #   goals_split_post_reg_season_away_goals(team_id)["Regular Season"]
#   # end
#   #
#   # def post_season_away_goals(team_id)
#   #   goals_split_post_reg_season_away_goals(team_id)["Postseason"]
#   # end
#   #
#   # def regular_season_home_goals(team_id)
#   #   goals_split_post_reg_season_home_goals(team_id)["Regular Season"]
#   # end
#   #
#   # def post_season_home_goals(team_id)
#   #   goals_split_post_reg_season_home_goals(team_id)["Postseason"]
#   # end
#   #
#   # def regular_season_total_away_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.away_team_id.to_s
#   #       return regular_season_away_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def post_season_total_away_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.away_team_id.to_s
#   #       return post_season_away_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def regular_season_total_home_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.home_team_id.to_s
#   #       return regular_season_home_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def post_season_total_home_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.home_team_id.to_s
#   #       return post_season_home_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def against_regular_season_total_away_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.away_team_id.to_s
#   #       return regular_season_home_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def against_post_season_total_away_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.home_team_id.to_s
#   #       return post_season_away_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def against_regular_season_total_home_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.home_team_id.to_s
#   #       return regular_season_away_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def against_post_season_total_home_goals_scored(team_id)
#   #   @game_collection.games_list.map do |game|
#   #     if team_id == game.home_team_id.to_s
#   #       return post_season_away_goals(team_id).sum
#   #     end
#   #   end
#   # end
#   #
#   # def regular_season_average_away_goals(team_id)
#   #   regular_season_total_away_goals_scored(team_id) / regular_season_away_goals(team_id).length
#   # end
#   #
#   # def post_season_average_away_goals(team_id)
#   #   post_season_total_away_goals_scored(team_id) / post_season_away_goals(team_id).length
#   # end
#   #
#   # def regular_season_average_home_goals(team_id)
#   #   regular_season_total_home_goals_scored(team_id) / regular_season_home_goals(team_id).length
#   # end
#   #
#   # def post_season_average_home_goals(team_id)
#   #   post_season_total_home_goals_scored(team_id) / post_season_home_goals(team_id).length
#   # end
#   #
#   # def against_regular_season_average_away_goals(team_id)
#   #   against_regular_season_total_away_goals_scored(team_id) / regular_season_home_goals(team_id).length
#   # end
#   #
#   # def against_post_season_average_away_goals(team_id)
#   #   against_post_season_total_away_goals_scored(team_id) / post_season_home_goals(team_id).length
#   # end
#   #
#   # def against_regular_season_average_home_goals(team_id)
#   #   against_regular_season_total_home_goals_scored(team_id) / regular_season_away_goals(team_id).length
#   # end
#   #
#   # def against_post_season_average_home_goals(team_id)
#   #   against_post_season_average_home_goals(team_id) / post_season_away_goals(team_id).length
#   # end
#   #
#   # def split_post_reg_season(team_id)
#   #   @game_collection.games_list.reduce({}) do |acc, game|
#   #     if game.away_team_id.to_s == team_id || game.home_team_id.to_s == team_id
#   #       (acc[game.type] ||= []) << game.game_id.to_s
#   #     end
#   #     acc
#   #   end
#   # end
#   #
#   # def regular_season(team_id)
#   #   x = split_post_reg_season(team_id)["Regular Season"]
#   #   y = group_arrays_by_season(x)
#   #   transform_key_into_season(y)
#   # end
#   #
#   # def post_season(team_id)
#   #   x = split_post_reg_season(team_id)["Postseason"]
#   #   y = group_arrays_by_season(x)
#   #   transform_key_into_season(y)
#   # end
#   #
#   # def split_post_reg_season_wins(team_id)
#   #   @game_collection.games_list.reduce({}) do |acc, game|
#   #     if ((game.away_team_id.to_s == team_id) && (game.away_goals > game.home_goals)) || ((game.home_team_id.to_s == team_id) && (game.home_goals > game.away_goals))
#   #       (acc[game.type] ||= []) << game.game_id.to_s
#   #     end
#   #     acc
#   #   end
#   # end
#   #
#   # def regular_season_wins(team_id)
#   #   x = split_post_reg_season_wins(team_id)["Regular Season"]
#   #   y = group_arrays_by_season(x)
#   #   transform_key_into_season(y)
#   # end
#   #
#   # def post_season_wins(team_id)
#   #   x = split_post_reg_season_wins(team_id)["Postseason"]
#   #   y = group_arrays_by_season(x)
#   #   transform_key_into_season(y)
#   # end
#   #
#   # def average_wins_regular_season(team_id)
#   #   # x = regular_season_wins(team_id).values.sum
#   #   # y = regular_season(team_id).values.sum
#   #   # (x.to_f / y).round(2)
#   #   hash = {}
#   #   regular_season_wins(team_id).map do |key, value|
#   #     total = regular_season(team_id)[key]
#   #     if total != nil
#   #       hash[key] = (value.to_f / total).round(2)
#   #     end
#   #   end
#   # end
#   #
#   # def average_wins_post_season(team_id)
#   #   # x = post_season_wins(team_id).values.sum
#   #   # y = post_season(team_id).values.sum
#   #   # (x.to_f / y).round(2)
#   #   hash = {}
#   #   post_season_wins(team_id).map do |key, value|
#   #     total = post_season(team_id)[key]
#   #     if total != nil
#   #       hash[key] = (value.to_f / total).round(2)
#   #     end
#   #   end
#   # end
#   #
#   # def average_wins_by_team_per_season(team_id)
#   #   final_total_won_games = {}
#   #   winning_game_ids(team_id).map do |key, value|
#   #     total_games = total_games_by_season(team_id)[key]
#   #     if total_games != nil
#   #       final_total_won_games[key] = ((value.to_f / total_games) * 100).round(2)
#   #     end
#   #   end
#   #   final_total_won_games
#   # end
#   #
#   #
#   #
#   #
#   #
#   #
#   #
#   # def total_games_by_season(team_id)
#   #   games =  @game_team_collection.game_team_list.map do |game_team|
#   #     if game_team.team_id.to_s == team_id
#   #       game_team.game_id.to_s
#   #     end
#   #   end.compact
#   #   grouped_games = group_arrays_by_season(games)
#   #   transform_key_into_season(grouped_games)
#   # end
#   #
#   # def winning_game_ids(team_id)
#   #   wins =  @game_team_collection.game_team_list.map do |game_team|
#   #     if (game_team.team_id.to_s == team_id) && (game_team.result == "WIN")
#   #       game_team.game_id.to_s
#   #     end
#   #   end.compact
#   #   grouped_wins = group_arrays_by_season(wins)
#   #   transform_key_into_season(grouped_wins)
#   # end
#   #
#   # def group_arrays_by_season(game_id_array)
#   #   game_id_array.group_by do |game_id|
#   #     game_id[0..3]
#   #   end
#   # end
#   #
#   # def transform_key_into_season(team_collection)
#   #   total = {}
#   #   team_collection.map do |key, value|
#   #     total[key + (key.to_i + 1).to_s] = value.length
#   #   end
#   #   total
#   # end
#   #
#   # def average_win_percentage(team_id)
#   #   won_games = winning_game_ids(team_id).values.sum
#   #   total_games = total_games_by_season(team_id).values.sum
#   #   (won_games.to_f / total_games).round(2)
#   # end
# end