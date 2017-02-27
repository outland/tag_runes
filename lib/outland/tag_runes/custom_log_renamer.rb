class Logger
  class LogDevice

  private
  
    alias_method :orig_shift_log_period, :shift_log_period
    
    # Override the shift method to allow us to control the file name.
    def shift_log_period(period_end)
      orig_shift_log_period(period_end)
      log_dir = File.dirname(@filename)
      return true unless File.directory?("#{log_dir}/rot")    # standard behavior unless rot dir exists
      Dir.glob("#{@filename}.*").each do |fn|
        base = File.basename(fn).gsub(/\.log\.(\d\d\d\d)(\d\d)(\d\d)$/, '-\1-\2-\3.log')
        File.rename fn, "#{log_dir}/rot/#{base}"
      end
      true
    end

  end
end
