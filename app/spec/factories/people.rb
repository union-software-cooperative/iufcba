FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@iuf.org" }

  factory :person do
    first_name "Test"
    last_name "Tester"
    title "MyString"
    address "MyText"
    mobile "+61 439 541 888"
    fax "MyString"
    email
    password "asdfasdf"
    password_confirmation "asdfasdf"
    association :union, factory: :union
    
    factory :admin do |f|
      f.union { owner_union }
    end

    factory :authorized_person do |f|
      f.authorizer { admin }
    end
  end

end
