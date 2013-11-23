Fabricator(:user) do
  full_name { Faker::Internet.user_name }
  email { Faker::Internet.email }
  password { "password" }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
