class ProjectSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name

  has_many :members, serializer: MemberSerializer
end
