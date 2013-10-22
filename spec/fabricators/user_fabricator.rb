Fabricator(:user) do
  full_name { Faker::Internet.user_name }
  email { Faker::Internet.email }
  password { "password" }
end
