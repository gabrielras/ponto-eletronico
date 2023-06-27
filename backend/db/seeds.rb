# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

manager = User.create!(name: 'Brendon', email: "gestor@gmail.com", password: '123456')

company = Company.create(name: "UFC")

role_manager = Role.create!(user: manager, company: company, role_type: 'manager')

[1,2,3,4,5].each do |colab|
  collaborator =  User.create!(name: Faker::Name.name, email: "colab#{colab}@gmail.com", password: '123456')
  role_collaborator = Role.create!(user: collaborator, company: company, role_type: 'collaborator_active')

  [1,2,3,4,5].each do |day|
    Schedule.create!(
      role: role_collaborator,
      closing_date: Time.zone.now + 5.year,
      start_date: Time.zone.now,
      start_time_hour: 8,
      start_time_minute: 0,
      initial_interval_hour: 12,
      initial_interval_minute: 0,
      final_interval_hour: 13,
      final_interval_minute: 0,
      final_time_hour: 18,
      final_time_minute: 0,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
    )

    point_presence = PointPresence.create!(
      role: role_collaborator,
      state: :adiantado,
      schedule_time: 'start_time',
      latitude: '15,23456',
      longitude: '-15,23456',
      local_name: 'Fortaleza'
    )

    time = Time.zone.now.change(hour: 7, min: 30, sec: 0) - day.days
    point_presence.created_at = time
    point_presence.updated_at = time
    point_presence.save!

    point_presence = PointPresence.create!(
      role: role_collaborator,
      state: :pontual,
      schedule_time: 'initial_interval',
      latitude: '15,23456',
      longitude: '-15,23456',
      local_name: 'Fortaleza'
    )

    time = Time.zone.now.change(hour: 12, min: 0, sec: 0) - day.days
    point_presence.created_at = time
    point_presence.updated_at = time
    point_presence.save!

    point_presence = PointPresence.create!(
      role: role_collaborator,
      state: :atrasado,
      schedule_time: 'final_interval',
      latitude: '15,23456',
      longitude: '-15,23456',
      local_name: 'Fortaleza'
    )

    time = Time.zone.now.change(hour: 14, min: 30, sec: 0) - day.days
    point_presence.created_at = time
    point_presence.updated_at = time
    point_presence.save!

    point_presence = PointPresence.create!(
      role: role_collaborator,
      state: :atrasado,
      schedule_time: 'final_time',
      latitude: '15,23456',
      longitude: '-15,23456',
      local_name: 'Fortaleza'
    )

    time = Time.zone.now.change(hour: 19, min: 30, sec: 0) - day.days
    point_presence.created_at = time
    point_presence.updated_at = time
    point_presence.save!
  end
end