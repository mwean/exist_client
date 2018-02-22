require "httparty"
require "logger"

require_relative "exist_client/version"
require_relative "exist_client/config"
require_relative "exist_client/logical_date"
require_relative "exist_client/report_period"
require_relative "exist_client/reporter"
require_relative "exist_client/time_tracking"
require_relative "exist_client/tasks"

module ExistClient
  class << self
    include LogicalDate

    REPORTERS = [TimeTracking, Tasks]

    def setup
      puts "Installing ExistClient..."
      Config.setup # TODO: Pass in optional data path
      REPORTERS.each(&:setup)
    end

    def report
      log "Starting report"

      # TODO: Pass in optional data path
      # Config.set_data_path()
      last_report_date = Date.parse(Config.last_report_date_file.read.strip)
      report_period = ReportPeriod.new(last_report_date)

      unless report_period.valid?
        log "Report period is not valid"
        exit 1
      end

      Config.enabled_reporters.each do |reporter|
        reporter.new(report_period).report
      end

      Config.last_report_date_file.write(logical_date(Time.now) - 1)

      log "Done"
    end

    def post(values)
      log values.to_json, indent: 1

      headers = {
        "Authorization" => "Bearer #{ENV.fetch("EXIST_API_KEY")}",
        "Content-Type" => "application/json"
      }

      response = HTTParty.post("https://exist.io/api/1/attributes/update/", body: values.to_json, headers: headers)

      if response.success?
        log "Success!", indent: 1
      else
        log "Error!", indent: 1
        log response.code, indent: 1
        log response.body, indent: 1
        exit 1
      end
    end

    def log(message, indent: 0)
      logger.info("#{"\t" * indent}#{message}")
    end

    def logger
      @logger ||= Logger.new(STDOUT).tap do |log|
        log.formatter = lambda do |severity, datetime, _, msg|
          format("[%s] %5s: %s\n", datetime.strftime("%F %T"), severity, msg)
        end
      end
    end
  end
end
