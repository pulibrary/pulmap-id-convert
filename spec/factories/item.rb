FactoryGirl.define do
  to_create(&:save)

  sequence :ark do
    minter = Noid::Minter.new(template: '.rdedeedd')
    minter.mint
  end

  sequence :guid do
    UUIDTools::UUID.random_create
  end

  sequence :image do
    rand(100_000_000_000)
  end

  factory :item do
    ark
    guid
    image
  end
end
