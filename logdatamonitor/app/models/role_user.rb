class RoleUser < ApplicationRecord
  belongs_to :role
  belongs_to :user, inverse_of: :role_users

  validates :role, presence: true
  validates :user, presence: true

  ApplicationHelper::ROLE_FOR_METHODS.each do |rname|
    define_method "is_#{rname}?" do
      self.role.name == rname
    end
  end

  # Нужно из-за JSON-формата поля data
  def data=(value)
    self[:data] = {data: value}
  end
end
