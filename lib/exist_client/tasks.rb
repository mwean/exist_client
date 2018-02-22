require_relative "tasks/task"

module ExistClient
  class Tasks < Reporter
    def report
      ExistClient.log "Reporting completed tasks"
      completed_tasks = plugin.completed_tasks(report_period, data_path).map { |task_data| Task.new(task_data) }
      grouped_tasks = filter_tasks(completed_tasks).group_by(&:logical_date)

      if grouped_tasks.any?
        ExistClient.log "Found data for the following dates:", indent: 1
        ExistClient.log grouped_tasks.keys.sort.map { |date| date.strftime("%-m/%-d") }.join(", "), indent: 1
      else
        ExistClient.log "No new data found", indent: 1
        return
      end

      values = grouped_tasks.map do |date, tasks|
        {
          name: "tasks_completed",
          date: date.to_s,
          value: tasks.size
        }
      end

      ExistClient.log "Reporting completed tasks data...", indent: 1
      ExistClient.post(values)
    end

    private

    def filter_tasks(tasks)
      tasks.select { |task| report_period.include?(task.completed_at) }
    end
  end
end
