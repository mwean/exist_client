require_relative "time_tracking/entry"
require_relative "time_tracking/qbserve"

module ExistClient
  class TimeTracking
    PRODUCTIVITY_LABELS = {
      productive: "productive_min",
      neutral: "neutral_min",
      distracting: "distracting_min"
    }

    class << self
      def report
        grouped_entries = filter_entries(Qbserve.entries.group_by(&:logical_date))

        if grouped_entries.any?
          ExistClient.log "Found data for the following dates:"
          ExistClient.log grouped_entries.keys.sort.map { |date| date.strftime("%-m/%-d") }.join(", ")
        else
          ExistClient.log "No new data found"
          return
        end

        values = grouped_entries.flat_map do |date, date_entries|
          build_productivity_values(date, date_entries)
        end

        ExistClient.log "Reporting time tracking data..."
        ExistClient.post(values)
      end

      def data_path
        DATA_PATH.join("timesheets")
      end

      private

      def filter_entries(entries)
        entries.reject { |date, _| date <= ExistClient.last_report_date || date == Date.today }.to_h
      end

      def build_productivity_values(date, date_entries)
        date_entries.group_by(&:productivity).map do |productivity, productivity_entries|
          {
            name: PRODUCTIVITY_LABELS.fetch(productivity),
            date: date.to_s,
            value: productivity_entries.sum(&:seconds) / 60
          }
        end
      end
    end
  end
end
