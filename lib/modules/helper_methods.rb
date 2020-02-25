module Helperable
  def get_season_games(season)
    @game_collection.games_list.find_all do |game|
      game.season == season
    end
  end
end
