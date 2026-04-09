puts "🌱 Seeding admin user..."

user = User.find_or_initialize_by(email: "admin@gmail.com")

user.password = "admin123"
user.password_confirmation = "admin123"
user.admin = true
user.confirmed_at = Time.current

user.save!

puts "✅ Admin ready: #{user.email}"