class Coordinate < ApplicationRecord
  enum content_type: {
    head: 0,
    tail: 1,
    body: 2,
    food: 3,
    hazard: 4
  }
end
