module Helperable
  def get_season_games(season)
    @game_collection.games_list.find_all do |game|
      game.season == season
    end
  end

  def get_season_game_teams(season)
    @game_team_collection.game_team_list.find_all do |game_team|
      game_team.game_id[0..3] == season[0..3]
    end
  end
end
