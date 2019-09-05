require 'server_metrics'
require 'time'

def parse_descriptors_info
	descriptors = `cat /proc/sys/fs/file-nr`
	descriptors = descriptors.strip.split("\t").map(&:to_i)
	{current: descriptors[0], unused: descriptors[1], max: descriptors[2]}
end

def get_system_metrics
	metrics = [ServerMetrics::Network, ServerMetrics::Cpu, ServerMetrics::Disk, ServerMetrics::Memory]
	metrics_human_name = ["network", "cpu", "disk", "memory", "system_info", "descriptors", "time"]
	result = {}

	metrics.each_with_index do |m, index|
		metric = m.new
		metric.run
		sleep 1 if m == ServerMetrics::Network || m == ServerMetrics::Cpu
		metric.build_report
		result[metrics_human_name[index]] = metric.data
	end
	result[metrics_human_name[-3]] = ServerMetrics::SystemInfo.to_h
	result[metrics_human_name[-2]] = parse_descriptors_info
	result[metrics_human_name[-1]] = Time.now

	result
end
