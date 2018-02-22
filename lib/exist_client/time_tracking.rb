require_relative "time_tracking/entry"

module ExistClient
  class TimeTracking < Reporter
    PRODUCTIVITY_LABELS = {
      productive: "productive_min",
      neutral: "neutral_min",
      distracting: "distracting_min"
    }

    def self.setup
      Config.data_path_for(self).mkpath
    end

    def report
      ExistClient.log "Reporting time tracking"
      all_entries = plugin.entries(report_period, data_path).map { |entry_data| Entry.new(entry_data) }
      grouped_entries = filter_entries(all_entries).group_by(&:logical_date)

      if grouped_entries.any?
        ExistClient.log "Found data for the following dates:", indent: 1
        ExistClient.log grouped_entries.keys.sort.map { |date| date.strftime("%-m/%-d") }.join(", "), indent: 1
      else
        ExistClient.log "No new data found", indent: 1
        return
      end

      values = grouped_entries.flat_map do |date, date_entries|
        build_productivity_values(date, date_entries)
      end

      ExistClient.log "Reporting data...", indent: 1
      ExistClient.post(values)
    end

    private

    def filter_entries(entries)
      entries.select { |entry| report_period.include?(entry.start_time) }
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
