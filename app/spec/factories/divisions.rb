FactoryGirl.define do
  factory :division do
    name "MyString"
    short_name "MyString"
    colour1 "red"
    colour2 "white"
    after :create do |b|
    	b.update_column(:logo, File.join("spec", "fixtures", "logo.png"))
  	end
  end
end
