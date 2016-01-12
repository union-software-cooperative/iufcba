FactoryGirl.define do
  factory :post do
    body "MyText"
		attachment "MyString"
		person nil
		parent nil
  end
end
