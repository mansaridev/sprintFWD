class TeamSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :created_at, :updated_at

  has_many :members
end
