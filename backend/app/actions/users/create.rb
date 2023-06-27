# frozen_string_literal: true

module Users
  class Create < Actor
    input :attributes, type: Hash

    output :user, type: User

    def call
      self.user = User.new(attributes.except(:role_type, :company_name))

      if attributes["role_type"] == 'manager'
        Company.create!(name: attributes[:company_name])
      end

      self.user.save!
    rescue => exception
      fail!(error: exception.message)
    end
  end
end
