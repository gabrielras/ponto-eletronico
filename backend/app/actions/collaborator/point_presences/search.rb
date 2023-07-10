# frozen_string_literal: true

module Collaborator
  module PointPresences
    class Search < Actor
      input :date, type: Date
      input :user, type: User

      output :data, type: Array
      output :schedule, type: Schedule, default: nil

      def call
        self.data = []
        self.schedule = Schedule.joins(:role).where(role: { user_id: user.id }).where('schedules.closing_date::date >= ?', date).where('schedules.start_date::date <= ?', date.end_of_day).where('schedules.created_at::date >= ?', date).where("schedules.#{date.strftime('%A').downcase} = ?", true).last

        return if schedule.blank?
        self.data = [
          tempo_total: total_time,
          tempo_inicial: {
            padrao: time('start_time') || "",
            real: point_presence('start_time')&.created_at&.strftime('%H:%M') || "",
            situacao: CurrentState.state(point_presence('start_time'), time('start_time')) || "",
          },
          intervalo_inicial: {
            padrao: time('initial_interval') || "",
            real: point_presence('initial_interval')&.created_at&.strftime('%H:%M') || "",
            situacao: CurrentState.state(point_presence('initial_interval'), time('initial_interval')) || "",
          },
          intervalo_final: {
            padrao: time('final_interval') || "",
            real: point_presence('final_interval')&.created_at&.strftime('%H:%M') || "",
            situacao: CurrentState.state(point_presence('final_interval'), time('final_interval')) || "",
          },
          tempo_final: {
            padrao: time('final_time') || "",
            real: point_presence('final_time')&.created_at&.strftime('%H:%M') || "",
            situacao: CurrentState.state(point_presence('final_time'), time('final_time')) || "",
          }
        ]
      rescue => e
        fail!(error: "Houve um erro: #{e.message}")
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

      def total_time
        result = tempo_final - tempo_inicial
        result = result - intervalo if intervalo.present?
        horas = result / 3600
        minutos = (result % 3600) / 60

        return format('%02d:%02d', horas, minutos)
      rescue
        ""
      end

      def tempo_final
        return point_presence('final_time')&.created_at if point_presence('final_time').present?
        return Time.zone.now if time('final_time') > Time.zone.now
        time('final_time')
      end

      def tempo_inicial
        point_presence('start_time')&.created_at
      end
  
      def intervalo
        return nil if point_presence('initial_interval').blank?
        if point_presence('final_interval').present?
          return point_presence('final_interval')&.created_at - point_presence('initial_interval')&.created_at
        end

        if time('final_time') > Time.zone.now
          return Time.zone.now - point_presence('initial_interval')&.created_at 
        else
          return time('final_time') - point_presence('initial_interval')&.created_at 
        end
      end
    end
  end
end
