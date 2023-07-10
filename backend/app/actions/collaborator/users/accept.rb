module Collaborator
  module Users
    class Accept < Actor
      input :user, type: User

      def call
        fail!(error: 'Não existe convite') if user.role.blank?
        fail!(error: 'Não é mais possível aceitar') unless user.role.role_type == 'collaborator_pending'

        user.role.update(role_type: 'collaborator_active')
      rescue StandardError => e
        fail!(error: "Houve um erro: #{e.message}")
      end
    end
  end
end
