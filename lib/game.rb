class Game
  attr_reader :game_id,
              :season,
              :type,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals

  def initialize(info_params)
    @game_id = info_params[:game_id].to_i
    @season = info_params[:season]
    @type = info_params[:type]
    @away_team_id = info_params[:away_team_id].to_i
    @home_team_id = info_params[:home_team_id].to_i
    @away_goals = info_params[:away_goals].to_i
    @home_goals = info_params[:home_goals].to_i
  end
end
