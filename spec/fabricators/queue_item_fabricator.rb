Fabricator(:queue_item) do
  user
  video
  position { sequence(:position, 1) }
end
