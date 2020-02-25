class GameTeam

  attr_reader :game_id,
              :team_id,
              :home_away,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles

  def initialize(details)
    @game_id = details[:game_id]
    @team_id = details[:team_id].to_i
    @home_away = details[:home_away]
    @result = details[:result]
    @settled_in = details[:settled_in]
    @head_coach = details[:head_coach]
    @goals = details[:goals].to_i
    @shots = details[:shots].to_i
    @tackles = details[:tackles].to_i
  end
end
