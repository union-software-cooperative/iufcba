FactoryGirl.define do
  factory :company do
    name "Test Company"
    type "Company"
    www "www.company.com"
    short_name "test"
    after(:create) do |company|
      company.divisions << FactoryGirl.create(:division, name: "dairy")
    end
  end

  factory :company_with_different_division do
    name "Other Company"
    type "Company"
    www "www.company.com"
    short_name "test"
    after(:create) do |company|
      company.divisions << FactoryGirl.create(:division, name: "different division")
    end
  end

  factory :union do
    name "Test Union"
    type "Union"
    www "www.union.com"
    short_name "tu"

    after(:create) do |company|
      company.divisions << FactoryGirl.create(:division, name: "dairy")
    end

    factory :owner do
      name "Owner"
      short_name 'IUF'
      after(:create) do |company|
        company.divisions << FactoryGirl.create(:division, name: "brewery")
      end
    end
  end
end
