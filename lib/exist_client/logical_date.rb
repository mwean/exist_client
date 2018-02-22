module ExistClient
  module LogicalDate
    def logical_date(time)
      local_time = time.getlocal
      date = local_time.to_date
      date -= 1 if local_time.hour < Config.cutoff_hour
      date
    end
  end
end
