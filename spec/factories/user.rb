# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    name { 'Lincoln' }
    email { 'lincolnrodrs@gmail.com' }
    password { '123456' }
  end
end
