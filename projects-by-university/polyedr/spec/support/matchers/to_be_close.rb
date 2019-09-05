EPS = 1.0e-12

# проверка на приближённое равенство
RSpec::Matchers.define :be_close_to do |expected|
  match do |actual|

   res = true
   res = false if actual.class != expected.class && [R3, Segment].include?(actual.class)
 
   (actual.instance_variables & [:@x, :@y, :@z, :@beg, :@fin]).inject(res) do |res, var|
       res and ((actual.instance_variable_get(var) - expected.instance_variable_get(var)).abs < EPS)
    end 

  end
end
