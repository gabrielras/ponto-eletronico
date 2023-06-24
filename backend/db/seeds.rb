# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
manager = User.create!(name: 'Brendon', email: "brendon@gmail.com", password: '123456')
collaborator =  User.create!(name: 'Gabriel', email: "gabriel@gmail.com", password: '123456')

User.create!(name: 'teste', email: "teste@gmail.com", password: '123456')

company = Company.create(name: "UFC")

role_manager = Role.create!(user: manager, company: company, role_type: 'manager')
role_collaborator = Role.create!(user: collaborator, company: company, role_type: 'collaborator_active')

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
  final_time_hour: 6,
  final_time_minute: 0,
  monday: true,
  tuesday: true,
  wednesday: true,
  thursday: true,
  friday: true,
)

[1,2,3,4,5].each do |day|
  [:start_time, :initial_interval, :final_interval, :final_time].each do |schedule_time|
    point_presence = PointPresence.create!(
      role: role_collaborator,
      state: [:adiantado, :atrasado, :pontual].sample,
      schedule_time: schedule_time,
      geocoding: {
        local: 'Fortaleza'
      }.to_json
    )

    time = Time.zone.now - day.days
    point_presence.created_at = time
    point_presence.updated_at = time
    point_presence.save!
  end
end