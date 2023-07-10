# frozen_string_literal: true

module Collaborator
  module Users
    class Reject < Actor
      input :user, type: User

      def call
        fail!(error: 'Não existe convite') if user.role.blank?
        fail!(error: 'Não é mais possível recusar') unless user.role.role_type == 'collaborator_pending'?

        user.role.destroy
      rescue StandardError => e
        fail!(error: "Houve um erro: #{e.message}")
      end
    end
  end
end
