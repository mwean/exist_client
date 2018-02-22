module ExistClient
  class Tasks < Reporter
    class Task
      include LogicalDate

      attr_reader :completed_at

      def initialize(data)
        @completed_at = data.fetch(:completed_at)
      end

      def logical_date
        super(completed_at)
      end
    end
  end
end
