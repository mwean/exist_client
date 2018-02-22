module ExistClient
  class Reporter
    attr_reader :report_period, :plugin, :data_path

    def self.setup
    end

    def self.metric_name
      str = name.split("::").last
      str.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      str.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      str.tr!("-", "_")
      str.downcase!
    end

    def initialize(report_period)
      @report_period = report_period
      @plugin = Config.plugin_for(self.class)
      @data_path = Config.data_path_for(self.class)
    end
  end
end
