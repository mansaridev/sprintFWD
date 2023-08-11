# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :members, dependent: :destroy
end
