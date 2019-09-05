class Disk < ApplicationRecord
  belongs_to :hot_catch_app

  # validates :name, presence: true
  # validates :filesystem, presence: true
  # validates :size, presence: true
  # validates :used, presence: true
  # validates :mounted_on, presence: true
end
