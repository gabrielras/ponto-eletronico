# frozen_string_literal: true

module Users
  class Update < Actor
    input :attributes, type: Hash
    input :user, type: User

    def call
      attributes.delete(:password) if attributes[:password].blank?
      user.update!(attributes)
    rescue => exception
      fail!(error: exception.message)
    end
  end
end
