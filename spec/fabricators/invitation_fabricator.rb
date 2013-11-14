Fabricator(:invitation) do
  recipient_name { Faker::Internet.user_name }
  recipient_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(5) }
end
