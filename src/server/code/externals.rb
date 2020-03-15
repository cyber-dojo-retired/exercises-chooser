# frozen_string_literal: true
require_relative 'external_exercises_start_points'
require_relative 'external_http'

class Externals

  def exercises_start_points
    @exercises_start_points ||= ExternalExercisesStartPoints.new(exercises_start_points_http)
  end
  def exercises_start_points_http
    @exercises_start_points_http ||= ExternalHttp.new
  end

end
