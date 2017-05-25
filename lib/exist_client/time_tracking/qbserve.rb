require "json"

module ExistClient
  class TimeTracking
    class Qbserve
      PRODUCTIVITY_MAPPINGS = {
        1 => :productive,
        0 => :neutral,
        -1 => :distracting
      }

      class << self
        def entries
          ExistClient.log "Looking for timesheets since #{ExistClient.last_report_date.strftime("%-m/%-d")}"

          timesheets.reduce([]) do |combined_entries, file|
            data = JSON.parse(file.read)
            activities = extract_activities(data)
            log = data.fetch("history").fetch("log")

            combined_entries + log.map { |log_entry| build_entry(log_entry, activities) }
          end
        end

        private

        def timesheets
          TimeTracking.data_path.children.select do |file|
            timestamp = file.basename.to_s.split("_").first.to_i
            since_last_report?(timestamp) && before_today?(timestamp)
          end
        end

        def since_last_report?(timestamp)
          timestamp >= ExistClient.last_report_date.to_time.to_i
        end

        def before_today?(timestamp)
          today = Date.today
          timestamp < Time.local(today.year, today.month, today.day, CUTOFF_HOUR).to_i
        end

        def extract_activities(data)
          categories = extract_categories(data)
          raw_activities = data.fetch("history").fetch("activities")
          raw_activities.map { |id, info| [id.to_i, categories.fetch(info.fetch("category_id"))] }.to_h
        end

        def extract_categories(data)
          data.fetch("history").fetch("categories").map { |id, info| [id.to_i, info.fetch("productivity")] }.to_h
        end

        def build_entry(data, activities)
          productivity = PRODUCTIVITY_MAPPINGS.fetch(activities.fetch(data.fetch("activity_id")))

          Entry.new(Time.at(data["start_time"]), data["duration"], productivity)
        end
      end
    end
  end
end
