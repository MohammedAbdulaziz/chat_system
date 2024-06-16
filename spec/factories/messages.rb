FactoryBot.define do
  factory :message do
    association :chat
    number { 1 }
    body { "Test message body" }
  end
end
