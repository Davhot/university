class Role < ApplicationRecord
  has_many :role_users

  validates :name, presence: true, uniqueness: true
  validates :info, presence: true, uniqueness: true
  validates :full_info, presence: true

  def self.create_main_roles
    r1 = Role.find_or_create_by(name: 'admin',
      info: 'Администратор',
      full_info: 'Администратор системы')
    r2 = Role.find_or_create_by(name: 'operator',
      info: 'Оператор',
      full_info: 'Оператор')
    [r1, r2]
  end

  ApplicationHelper::ROLE_FOR_METHODS.each do |rname|
    define_method "is_#{rname}?" do
      self.role_name_eng == rname
    end
  end
end
