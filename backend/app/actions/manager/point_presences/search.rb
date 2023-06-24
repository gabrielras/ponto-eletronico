# frozen_string_literal: true

module Manager
  module PointPresences
    class Search < Actor
      input :date, type: Date
      input :user, type: User

      output :data, type: Array

      def call
        self.data = []
        return if schedules.blank?

        schedules.each do |schedule|
          self.data << {
            user_name: schedule.role.user.name,
            user_email: schedule.role.user.email,
            tempo_inicial: {
              padrao: time(schedule, 'start_time'),
              real: point_presence(schedule, 'start_time')&.created_at&.strftime('%H:%M'),
              situacao: CurrentState.state(point_presence(schedule, 'start_time'), time(schedule, 'start_time')),
              geolocalizacao: point_presence(schedule, 'start_time')&.geocoding
            },
            intervalo_inicial: {
              padrao: time(schedule, 'initial_interval'),
              real: point_presence(schedule, 'initial_interval')&.created_at&.strftime('%H:%M'),
              situacao: CurrentState.state(point_presence(schedule, 'initial_interval'), time(schedule, 'initial_interval')),
              geolocalizacao: point_presence(schedule, 'initial_interval')&.geocoding
            },
            intervalo_final: {
              padrao: time(schedule, 'final_interval'),
              real: point_presence(schedule, 'final_interval')&.created_at&.strftime('%H:%M'),
              situacao: CurrentState.state(point_presence(schedule, 'final_interval'), time(schedule, 'final_interval')),
              geolocalizacao: point_presence(schedule, 'final_interval')&.geocoding
            },
            tempo_final: {
              padrao: time(schedule, 'final_time'),
              real: point_presence(schedule, 'final_time')&.created_at&.strftime('%H:%M'),
              situacao: CurrentState.state(point_presence(schedule, 'final_time'), time(schedule, 'final_time')),
              geolocalizacao: point_presence(schedule, 'final_time')&.geocoding
            }
          }
        end
      end

      private

      def point_presence(schedule, schedule_time)
        PointPresence.joins(role: :company)
                     .where(roles: { id: schedule.role.id })
                     .where(created_at: date.beginning_of_day..date.end_of_day)
                     .find_by(schedule_time: schedule_time)
      end

      def time(schedule, schedule_time)
        "#{schedule.send("#{schedule_time}_hour")}:#{schedule.send("#{schedule_time}_minute")}"
      end

      def schedules
        Schedule.joins(role: :company)
                .where(companies: { id: user.role.company_id })
                .where('schedules.closing_date >= ?', date)
                .where('schedules.start_date >= ?', date)
                .where("schedules.#{date.strftime('%A').downcase} = ?", true)
      end
    end
  end
end
