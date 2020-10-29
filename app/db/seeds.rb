# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
union = Union.new(short_name: "IUF", name: "International Union of Food, Agricultural, Hotel, Restaurant, Catering, Tobacco and Allied Workers' Association", www: "iuf.org")
union.save(validate: false)
user = Person.create!( email: "admin@iuf.org", password: "temptemp", password_confirmation: "temptemp", first_name: "Admin", union: union )
user.update!(invited_by: user, authorizer: user) # invite self for the sake of looking like a user
