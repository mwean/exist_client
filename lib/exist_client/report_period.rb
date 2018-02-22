module ExistClient
  class ReportPeriod
    include LogicalDate

    attr_reader :start_time, :end_time

    def initialize(last_report_date)
      date = last_report_date + 1
      end_date = logical_date(Time.now)

      @start_time = Time.new(date.year, date.month, date.day, Config.cutoff_hour)
      @end_time = Time.new(end_date.year, end_date.month, end_date.day, Config.cutoff_hour) - 1
    end

    def valid?
      start_time < end_time
    end

    def include?(time)
      time.between?(start_time, end_time)
    end
  end
end
