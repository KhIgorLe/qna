module ModuleHelpers
  RSpec::Matchers.define :be_is_author do |resource|
    match do |user|
      user.author_of?(resource)
    end
  end
end
