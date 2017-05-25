module ExistClient
  class TasksCompleted
    class Task
      include LogicalDate

      attr_reader :time

      def initialize(completion_time)
        @time = completion_time
      end
    end
  end
end
