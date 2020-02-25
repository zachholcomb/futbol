require_relative 'game_collection'
require_relative 'game_team_collection'
require_relative 'team_collection'

class SeasonStatTeam

  def initialize(game_team_collection, team_collection)
    @game_team_collection =game_team_collection
    @team_collection = team_collection
  end

  def get_season_game_teams(season)
    @game_team_collection.game_team_list.find_all do |game_team|
      game_team.game_id[0..3] == season[0..3]
    end
  end

  def get_team_ids_by_season(season)
    get_season_game_teams(season).map do |game_team|
      game_team.team_id
    end.uniq
  end

  def get_team_name(team_id)
    team_name_by_id = @team_collection.teams_list.find do |team|
      team.team_id == team_id
    end
    team_name_by_id.team_name
  end

  def get_tackles_by_team_season(team_id, season)#refactor to a reduce
    team_tackles = 0
    get_season_game_teams(season).each do |game_team|
      if game_team.team_id.to_s == team_id
        team_tackles += game_team.tackles
      end
    end
    team_tackles
  end

  def get_goals_by_team_season(team_id, season)#refactor to a reduce
    team_goals = 0
    get_season_game_teams(season).each do |game_team|
      if game_team.team_id.to_s == team_id
        team_goals += game_team.goals
      end
    end
    team_goals
  end

  def get_shots_by_team_season(team_id, season)
    team_shots = 0
    get_season_game_teams(season).each do |game_team|
      if game_team.team_id.to_s == team_id
        team_shots += game_team.shots
      end
    end
    team_shots
  end

  def team_shots_to_goal_ratio_by_season(team_id, season)
    total_goals = get_goals_by_team_season(team_id, season).to_f
    total_shots = get_shots_by_team_season(team_id, season)
    (total_shots / total_goals).round(3)
  end

  def create_team_data_by_season(season)
    get_team_ids_by_season(season).reduce({}) do |acc, team_id|
      acc[team_id.to_s] = {
        team_name: get_team_name(team_id),
        goal_ratio: team_shots_to_goal_ratio_by_season(team_id.to_s, season),
        tackles: get_tackles_by_team_season(team_id.to_s, season)
      }
      acc
    end
  end

  def most_accurate_team(season)
    accurate_team = create_team_data_by_season(season).min_by do |team, team_data|
      team_data[:goal_ratio]
    end
    accurate_team[1][:team_name]
  end

  def least_accurate_team(season)
    inaccurate_team = create_team_data_by_season(season).max_by do |team, team_data|
      team_data[:goal_ratio]
    end
    inaccurate_team[1][:team_name]
  end

  def most_tackles(season)
    team_tackles = create_team_data_by_season(season).max_by do |team, team_data|
      team_data[:tackles]
    end
    team_tackles[1][:team_name]
  end

  def fewest_tackles(season)
    team_tackles = create_team_data_by_season(season).min_by do |team, team_data|
      team_data[:tackles]
    end
    team_tackles[1][:team_name]
  end
end
