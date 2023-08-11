# frozen_string_literal: true

class Member < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true

  belongs_to :team
  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members
end
