FactoryGirl.define do
  to_create { |i| i.save }

  sequence :ark do |n|
    minter = Noid::Minter.new(:template => '.rdedeedd')
    minter.mint
  end

  sequence :guid do |n|
    UUIDTools::UUID.random_create 
  end

  sequence :image do |n|
    rand(1000000000000)
  end
  
  factory :item do
    ark
    guid
    image
  end
end