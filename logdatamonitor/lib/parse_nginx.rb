class ParseNginx
  attr_reader :data

  def parse_all_data(file)
    @data = File.open(file, 'r'){|file| file.readlines}
    # [IP, DATE]
    @data.map!{|x| [x.match(/(^\d+\.\d+\.\d+\.\d+)/)[1],
      DateTime.strptime(x.match(/\[(.*)\]/)[1], "%d/%b/%Y:%H:%M:%S %z"),
      x.scan(/".*?"/)[-1]]}
  end

  def parse_file_for_date(file, string_date, ip = nil, visitor = nil)
    @data = File.open(file, 'r'){|file| file.readlines}
    string_date = Regexp.new(string_date)
    @data = @data.select{|x| x =~ string_date}
  end
end
