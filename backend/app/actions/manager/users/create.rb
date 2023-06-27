# frozen_string_literal: true

module Manager
  module Users
    class Create < Actor
      input :user, type: User
      input :attributes, type: Hash

      def call
        ActiveRecord::Base.transaction do
          collaborator = User.find_by(email: attributes[:email])
          fail!(error: 'usuário não encontrado') if collaborator.blank?
          role = Role.create!(user: collaborator, company_id: user.role.company_id, role_type: 'collaborator_active')
          Schedule.create!(attributes.except(:email).merge(role: role, start_date: Time.zone.now, closing_date: (Time.zone.now + 5.year)))
        end
      end
    end
  end
end
