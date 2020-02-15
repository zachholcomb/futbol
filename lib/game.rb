class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue

  def initialize(info_params)
    @game_id = info_params[:game_id]
    @season = info_params[:season]
    @type = info_params[:type]
    @date_time = info_params[:date_time]
    @away_team_id = info_params[:away_team_id]
    @home_team_id = info_params[:home_team_id]
    @away_goals = info_params[:away_goals]
    @home_goals = info_params[:home_goals]
    @venue = info_params[:venue]
  end
end