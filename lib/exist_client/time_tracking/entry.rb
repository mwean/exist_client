module ExistClient
  class TimeTracking
    class Entry
      include LogicalDate

      attr_reader :time, :seconds, :productivity

      def initialize(start_time, seconds, productivity)
        @time = start_time
        @seconds = seconds
        @productivity = productivity
      end
    end
  end
end
