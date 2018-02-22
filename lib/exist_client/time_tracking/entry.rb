module ExistClient
  class TimeTracking < Reporter
    class Entry
      include LogicalDate

      attr_reader :start_time, :end_time, :seconds, :productivity

      def initialize(data)
        @start_time = data.fetch(:start_time)
        @end_time = data.fetch(:end_time)
        @productivity = data.fetch(:productivity)
        @seconds = end_time - start_time
      end

      def logical_date
        super(start_time)
      end
    end
  end
end
