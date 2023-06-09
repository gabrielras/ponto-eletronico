# frozen_string_literal: true

module Manager
  module Users
    class Destroy < Actor
      input :user, type: User

      def call
        ActiveRecord::Base.transaction do
          user.role.update!(role_type: 'collaborator_banned')
        end
      rescue => e
        fail!(error: "Houve um erro: #{e.message}")
      end
    end
  end
end
