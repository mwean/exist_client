module ExistClient
  module LogicalDate
    def logical_date
      date = time.to_date
      date -= 1 if time.hour < CUTOFF_HOUR
      date
    end
  end
end
