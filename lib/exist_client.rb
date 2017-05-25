require "httparty"
require "logger"

require_relative "exist_client/version"
require_relative "exist_client/logical_date"
require_relative "exist_client/time_tracking"
require_relative "exist_client/tasks_completed"

module ExistClient
  DATA_PATH = Pathname.new("~/.exist").expand_path
  LAST_REPORT_DATE_FILE = DATA_PATH.join("last_report_date")
  CUTOFF_HOUR = 5

  class << self
    def setup
      DATA_PATH.mkpath
      LAST_REPORT_DATE_FILE.write("2000-01-01")
      TimeTracking.data_path.mkpath
    end

    def report
      log "Starting report"

      TimeTracking.report
      TasksCompleted.report
      set_last_report_date
    end

    def acquire_attrs
    end

    def post(values)
      headers = {
        "Authorization" => "Bearer #{ENV.fetch("EXIST_API_KEY")}",
        "Content-Type" => "application/json"
      }

      response = HTTParty.post("https://exist.io/api/1/attributes/update/", body: values.to_json, headers: headers)

      if response.success?
        log "Success!"
      else
        log "Error!"
        log response.code
        log response.body
        exit 1
      end
    end

    def log(message)
      logger.info(message)
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def last_report_date
      @last_report_date ||= Date.parse(LAST_REPORT_DATE_FILE.read)
    end

    def set_last_report_date
      LAST_REPORT_DATE_FILE.write(Date.today)
    end
  end
end
