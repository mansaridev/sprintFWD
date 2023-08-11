# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :project_members, dependent: :nullify
  has_many :members, through: :project_members
end
