module CurrentState
  def self.state(point_presence = nil, time)
    hours, minutes = time.scan(/\d+/).map(&:to_i)
    new_time = Time.current.change(hour: hours, min: minutes).to_datetime

    return point_presence.state.capitalize if point_presence.present?
    return 'Aguardando' if new_time < Time.zone.now
    'Atrasado'
  end
end
