module GenerateNginxLogsHelper
  def append_nginx_log(time, filename = 'spec/nginx_files/nginx.logs')
    File.open(filename, 'a'){|file| file.puts time}
  end

  def generate_nginx_time(time, filename = 'spec/nginx_files/time.txt')
    File.open(filename, 'w'){|file| file.puts time}
  end

  def clear_nginx_log(filename = 'spec/nginx_files/nginx.logs')
    File.open(filename, 'w'){|file| file.write ''}
  end

  def clear_nginx_time(filename = 'spec/nginx_files/time.txt')
    File.open(filename, 'w'){|file| file.write ''}
  end
end
