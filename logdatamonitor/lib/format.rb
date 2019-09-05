# TODO: переписать в config/locales/ru.yml
module FormatDates
  extend ActiveSupport::Concern
  def format_moment(word)
    case word
    when "minute"
      "DD/MMM/YYYY:HH:mm"
    when "hour"
      "DD/MMM/YYYY:HH"
    when "day"
      "DD/MMM/YYYY"
    when "month"
      "MMM/YYYY"
    when "year"
      "YYYY"
    end
  end

  def format_c3_date(word)
    case word
    when "second"
      '%Y-%m-%d %H:%M:%S'
    when "minute"
      '%Y-%m-%d %H:%M'
    when "hour"
      '%Y-%m-%d %H'
    when "day"
      '%Y-%m-%d'
    when "month"
      '%Y-%m'
    when "year"
      '%Y'
    end
  end

  def format_show_datetime(word)
    case word
    when "minute"
      '%d.%m.%Y %H:%M'
    when "hour"
      '%d.%m.%Y %H'
    when "day"
      '%d.%m.%Y'
    when "month"
      '%m.%Y'
    when "year"
      '%Y'
    end
  end

  def datetime_format(step)
    case step
    when "month"
      format_date = "%m.%Y"
    when "day"
      format_date = "%D"
    when "hour"
      "%D %H"
    else
      "%D %H:%M"
    end
  end


  def format_nginx_datetime
    "%d/%b/%Y:%H:%M"
  end
end
