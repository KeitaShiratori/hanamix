json.array!(@rounds) do |round|
  json.extract! round, :id, :title, :description, :start_at, :end_at
  json.url round_url(round, format: :json)
end
