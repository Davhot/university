class MainMetric < ApplicationRecord
  belongs_to :hot_catch_app

  def h_swap_size
    number_to_human_size(swap_size * 2 ** 20)
  end
end
