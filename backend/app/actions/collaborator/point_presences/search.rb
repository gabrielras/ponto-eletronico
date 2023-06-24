# frozen_string_literal: true

module Collaborator
  module PointPresences
    class Search < Actor
      input :date, type: Date
      input :user, type: User

      output :data, type: Array

      def call
        self.data = []
        return if schedule.blank?

        self.data = [
          tempo_inicial: {
            padrao: time('start_time'),
            real: point_presence('start_time')&.created_at&.strftime('%H:%M'),
            situacao: CurrentState.state(point_presence('start_time'), time('start_time')),
            geolocalizacao: point_presence('start_time')&.geocoding
          },
          intervalo_inicial: {
            padrao: time('initial_interval'),
            real: point_presence('initial_interval')&.created_at&.strftime('%H:%M'),
            situacao: CurrentState.state(point_presence('initial_interval'), time('initial_interval')),
            geolocalizacao: point_presence('initial_interval')&.geocoding
          },
          intervalo_final: {
            padrao: time('final_interval'),
            real: point_presence('final_interval')&.created_at&.strftime('%H:%M'),
            situacao: CurrentState.state(point_presence('final_interval'), time('final_interval')),
            geolocalizacao: point_presence('final_interval')&.geocoding
          },
          tempo_final: {
            padrao: time('final_time'),
            real: point_presence('final_time')&.created_at&.strftime('%H:%M'),
            situacao: CurrentState.state(point_presence('final_time'), time('final_time')),
            geolocalizacao: point_presence('final_time')&.geocoding
          }
        ]
      end

      private

      def point_presence(schedule_time)
        PointPresence.where(role_id: user.role.id)
                     .where(created_at: date.beginning_of_day..date.end_of_day)
                     .find_by(schedule_time: schedule_time)
      end

      def time(schedule_time)
        "#{schedule.send("#{schedule_time}_hour")}:#{schedule.send("#{schedule_time}_minute")}"
      end

      def schedule
        Schedule.joins(:role)
                .where(role: { user_id: user.id })
                .where('schedules.closing_date >= ?', date)
                .where('schedules.start_date >= ?', date)
                .where("schedules.#{date.strftime('%A').downcase} = ?", true)
                .first
      end
    end
  end
end
