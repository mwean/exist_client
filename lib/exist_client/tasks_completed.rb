require_relative "tasks_completed/task"
require_relative "tasks_completed/omni_focus"

module ExistClient
  class TasksCompleted
    class << self
      def report
        grouped_tasks = filter_tasks(OmniFocus.completed_tasks.group_by(&:logical_date))

        if grouped_tasks.any?
          ExistClient.log "Found data for the following dates:"
          ExistClient.log grouped_tasks.keys.sort.map { |date| date.strftime("%-m/%-d") }.join(", ")
        else
          ExistClient.log "No new data found"
          return
        end

        values = grouped_tasks.map do |date, tasks|
          {
            name: "tasks_completed",
            date: date.to_s,
            value: tasks.size
          }
        end

        ExistClient.log "Reporting completed tasks data..."
        ExistClient.post(values)
      end

      private

      def filter_tasks(tasks)
        tasks.reject { |date, _| date <= ExistClient.last_report_date || date == Date.today }.to_h
      end
    end
  end
end
