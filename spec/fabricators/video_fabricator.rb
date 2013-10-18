Fabricator(:video) do
  title { sequence(:title, 1) {|i| "batman #{i}"} }
  description { Faker::Lorem.sentence(10) }
end
