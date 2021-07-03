class Coordinate < ApplicationRecord
  enum content_type: {
    head: 0,
    body: 1,
    food: 2,
    hazard: 3
  }

  scope :me, -> { where(is_me: true) }
end
