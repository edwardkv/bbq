FactoryBot.define do
  factory :event do
    association :user
    title { 'Событие ' }
    description { 'Шашлык' }
    address { 'Сочи, улица Портовая' }
    datetime { DateTime.parse('07.04.2021 11:00') }
  end
end