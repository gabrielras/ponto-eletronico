# frozen_string_literal: true

module Manager
  module PointPresences
    class Search < Actor
      input :name, type: String, default: nil
      input :date, type: Date
      input :user, type: User

      output :data, type: Array

      def call
        self.data = []
        return if schedules.blank?

        schedules.each do |schedule|
          next if total_time(schedule).blank?
          self.data << {
            user_name: schedule.role.user.name,
            tempo_total: total_time(schedule),
            tempo_inicial: {
              padrao: time(schedule, 'start_time') || "",
              real: point_presence(schedule, 'start_time')&.created_at&.strftime('%H:%M') || "",
              situacao: CurrentState.state(point_presence(schedule, 'start_time'), time(schedule, 'start_time')) || "",
              longitude: point_presence(schedule, 'start_time')&.longitude || "",
              latitude: point_presence(schedule, 'start_time')&.latitude || "",
              local_name: point_presence(schedule, 'start_time')&.local_name || ""
            },
            intervalo_inicial: {
              padrao: time(schedule, 'initial_interval') || "",
              real: point_presence(schedule, 'initial_interval')&.created_at&.strftime('%H:%M') || "",
              situacao: CurrentState.state(point_presence(schedule, 'initial_interval'), time(schedule, 'initial_interval')) || "",
              longitude: point_presence(schedule, 'initial_interval')&.longitude || "",
              latitude: point_presence(schedule, 'initial_interval')&.latitude || "",
              local_name: point_presence(schedule, 'initial_interval')&.local_name || ""
            },
            intervalo_final: {
              padrao: time(schedule, 'final_interval') || "",
              real: point_presence(schedule, 'final_interval')&.created_at&.strftime('%H:%M')|| "",
              situacao: CurrentState.state(point_presence(schedule, 'final_interval'), time(schedule, 'final_interval'))|| "",
              longitude: point_presence(schedule, 'final_interval')&.longitude || "",
              latitude: point_presence(schedule, 'final_interval')&.latitude || "",
              local_name: point_presence(schedule, 'final_interval')&.local_name || ""
            },
            tempo_final: {
              padrao: time(schedule, 'final_time') || "",
              real: point_presence(schedule, 'final_time')&.created_at&.strftime('%H:%M')|| "",
              situacao: CurrentState.state(point_presence(schedule, 'final_time'), time(schedule, 'final_time'))|| "",
              longitude: point_presence(schedule, 'final_time')&.longitude || "",
              latitude: point_presence(schedule, 'final_time')&.latitude || "",
              local_name: point_presence(schedule, 'final_time')&.local_name || ""
            }
          }
        end
      rescue => e
        fail!(error: "Houve um erro: #{e.message}")
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
        @schedules = Schedule.joins(role: [:user, :company])
                    .where(companies: { id: user.role.company_id })
                    .where('schedules.closing_date::date >= ?', date)
                    .where('schedules.created_at::date >= ?', date)
                    .where("schedules.#{date.strftime('%A').downcase} = ?", true)
                    .where('schedules.start_date::date <= ?', date.end_of_day)
        s = []
        @schedules.pluck(:role_id).uniq do |role_id|
          s << @schedules.joins(:role).where(role: { id: role_id }).last
        end
        @schedules = @schedules.where(id: s)
        @schedules = @schedules.joins(role: :user).where('users.name ILIKE ?', "%#{name}%") unless name.blank?
        @schedules
      end

      def total_time(schedule)
        result = tempo_final(schedule) - tempo_inicial(schedule)
        result = result - intervalo(schedule) if intervalo(schedule).present?
        horas = result / 3600
        minutos = (result % 3600) / 60

        return format('%02d:%02d', horas, minutos)
      rescue
        ""
      end

      def tempo_final(schedule)
        return point_presence(schedule, 'final_time')&.created_at if point_presence(schedule, 'final_time').present?
        return Time.zone.now if time(schedule, 'final_time') > Time.zone.now
        time('final_time')
      end

      def tempo_inicial(schedule)
        point_presence(schedule, 'start_time')&.created_at
      end
  
      def intervalo(schedule)
        return nil if point_presence(schedule, 'initial_interval').blank?

        if point_presence(schedule, 'final_interval').present?
          return point_presence(schedule, 'final_interval')&.created_at - point_presence(schedule, 'initial_interval')&.created_at
        end

        if time(schedule, 'final_time') > Time.zone.now
          return Time.zone.now - point_presence(schedule, 'initial_interval')&.created_at 
        else
          return time(schedule, 'final_time') - point_presence(schedule, 'initial_interval')&.created_at 
        end
      end
    end
  end
end
