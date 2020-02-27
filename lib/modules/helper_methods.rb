module Helperable
  def get_team_name(team_id)
    team_name_by_id = @team_collection.teams_list.find do |team|
      team.team_id.to_s == team_id
    end
    team_name_by_id.team_name
  end
end
