FactoryGirl.define do
  factory :company do
    name "Test Company"
		type "Company"
		www "www.company.com"
    short_name "test"
  end

  factory :union do
    name "Test Union"
		type "Union"
		www "www.union.com"
    short_name "tu"

    factory :owner do
      name "Owner"
      short_name 'IUF'
    end
  end
end
