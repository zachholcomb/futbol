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
      team.team_id.to_s == team_id
    end
    team_name_by_id.team_name
  end

  def get_team_ids_by_season(season)
    @game_teams_by_season[season].map do |game_team|
      game_team.team_id.to_s
    end.uniq
  end

  def total_team_games_by_game_type(team_id, game_type, season)
    total_games = 0

    total_games += @games_by_season[season].find_all do |game|
       game.away_team_id == team_id && game.type == game_type
     end.length

    total_games += @games_by_season[season].find_all do |game|
       game.home_team_id == team_id  && game.type == game_type
     end.length

    total_games
  end

  def total_team_wins_by_game_type(team_id, game_type, season)
    wins = 0
    wins += @games_by_season[season].find_all do |game|
      game.away_team_id == team_id && game.away_goals > game.home_goals && game.type == game_type
    end.length
    wins += @games_by_season[season].find_all do |game|
      game.home_team_id == team_id && game.home_goals > game.away_goals && game.type == game_type
    end.length
  end

  def team_win_percentage(team_id, game_type, season)
    total_wins = total_team_wins_by_game_type(team_id, game_type, season).to_f
    total_games = total_team_games_by_game_type(team_id, game_type, season)
    if total_games == 0
      return 0.00
    else
      ((total_wins / total_games) * 100).round(2)
    end
  end
end
