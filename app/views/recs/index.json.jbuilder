json.array!(@recs) do |rec|
  json.extract! rec, :id, :name, :tags, :start_date, :end_date, :attachment, :coverage, :union, :company
  json.url rec_url(rec, format: :json)
end
