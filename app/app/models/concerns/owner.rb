module Owner
  extend ActiveSupport::Concern

  def owner?(person)
    person.union.short_name == ENV['OWNER_UNION'] ||
      (ENV['OTHER_OWNERS']||"").split(',').include?(person.email)
  end
end
