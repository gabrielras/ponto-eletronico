# frozen_string_literal: true

module Collaborator
  module PointPresences
    class Create < Actor
      input :attributes, type: Hash
      input :user, type: User

      output :point_presence, type: PointPresence

      def call
        self.point_presence = PointPresence.new(attributes.merge(state: state, role: user.role))

        validate_weekday
        validate_unique_point_presence

        point_presence.save!
      end

      private

      def validate_weekday
        return if schedule.send("#{Time.zone.now.strftime('%A').downcase}")

        fail!(error: 'Esse dia da semana não está disponível')
      end

      def validate_unique_point_presence
        if PointPresence.where(:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(role_id: user.role.id, state: state).present?
          fail!(error: 'Já foi marcado o ponto.')
        end
      end

      def state
        time_default = Time.strptime("#{schedule.send("#{attributes[:schedule_time]}_hour")}:#{schedule.send("#{attributes[:schedule_time]}_minute")}", "%H:%M")
        if time_default + 10.minute < Time.zone.now 
          :atrasado
        elsif time_default - 10.minute > Time.zone.now 
          :adiantado
        else
          :pontual
        end
      end

      def schedule
        user.role.schedules.last
      end
    end
  end
end