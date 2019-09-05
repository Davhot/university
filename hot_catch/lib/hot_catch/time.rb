class Time
  def self.safe_strptime(value, format, default = nil)
    Time.strptime(value.to_s, format)
  rescue ArgumentError
    default
  end
end
