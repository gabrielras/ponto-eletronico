# frozen_string_literal: true

module Users
  class Update < Actor
    input :attributes, type: Hash
    input :user, type: User

    def call
      user.update!(attributes)
    end
  end
end
