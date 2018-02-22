require "yaml"

module ExistClient
  class Config
    DEFAULT_CUTOFF_HOUR = 5
    DEFAULT_DATA_PATH = "~/.exist"

    class << self
      def setup(relative_data_path = DEFAULT_DATA_PATH)
        set_data_path(relative_data_path)

        puts "  Creating directory at #{data_path}"
        data_path.mkpath

        puts "  Creating config file at #{config_file}"
        config_file.write("")

        last_report_date_file.write("2000-01-01")
      end

      def set_data_path(relative_data_path)
        @data_path = Pathname.new(relative_data_path).expand_path
      end

      def data_path
        @data_path ||= Pathname.new(DEFAULT_DATA_PATH).expand_path
      end

      def config_file
        @config_file ||= data_path.join("config.yml")
      end

      def cutoff_hour
        config_values.fetch("cutoff_hour", DEFAULT_CUTOFF_HOUR)
      end

      def data_path_for(reporter)
        data_path.join(reporter.metric_name)
      end

      def plugin_for(reporter)
        @plugins.fetch(reporter.metric_name)
      end

      def last_report_date_file
        data_path.join("last_report_date")
      end

      def enabled_reporters
        @enabled_reporters ||= plugins.keys.map { |reporter| constantize(reporter) }
      end

      private

      def config_values
        @config_values ||= YAML.load_file(config_file)
      end

      def plugins
        @plugins ||= load_plugins
      end

      def load_plugins
        plugin_map = config_values.fetch("plugins").map do |reporter, plugin|
          require "exist_client/#{plugin}"

          [reporter, constantize(plugin)]
        end

        plugin_map.to_h
      end

      def constantize(str)
        class_name = str.split("_").map(&:capitalize).join
        ExistClient.const_get(class_name)
      end
    end
  end
end
