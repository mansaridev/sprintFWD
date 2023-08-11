# frozen_string_literal: true

class ProjectMember < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :member, optional: true
end
