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

  def get_team_name(team_id)
    team_name_by_id = @team_collection.teams_list.find do |team|
      team.team_id == team_id
    end
    team_name_by_id.team_name
  end

  def get_team_ids_by_season(season)
    @game_teams_by_season[season].map do |game_team|
      game_team.team_id
    end.uniq
  end
end
