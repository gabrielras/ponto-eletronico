# frozen_string_literal: true

module Manager
  module Users
    class Update < Actor
      input :attributes, type: Hash
      input :user, type: User

      def call
        ActiveRecord::Base.transaction do
          fail!(error: 'usuário não encontrado') if user.blank?
          schedule = user.role.schedules.last
          schedule.update!(closing_date: Time.zone.now - 1.day)
          Schedule.create!(
            schedule.attributes.except('id', 'created_at', 'updated_at')
                               .merge(attributes.except(:email).merge(role: user.role, start_date: Time.zone.now, closing_date: (Time.zone.now + 5.year)))
          )
        end
      end
    end
  end
end
