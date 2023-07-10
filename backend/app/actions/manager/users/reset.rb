# frozen_string_literal: true

module Manager
  module Users
    class Reset < Actor
      input :user, type: User

      def call
        ActiveRecord::Base.transaction do
          user.update!(authentication_id: nil)
        end
      rescue => e
        fail!(error: "Houve um erro: #{e.message}")
      end
    end
  end
end
