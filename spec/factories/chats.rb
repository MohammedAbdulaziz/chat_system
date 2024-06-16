FactoryBot.define do
  factory :chat do
    association :application
    number { 1 }
  end
end
