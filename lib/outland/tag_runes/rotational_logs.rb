module Outland
module TagRunes

# Not in fact a Logger, but a Logger manager that handles daily log rotation
# with a custom naming pattern.

class RotationalLogs

  def initialize(opts={})
    @base = opts[:base] || 'rails'
  end

  def customize_rename(logger)
    # use singleton methods to pull out the internal LogDevice and then
    # override its shift_log_period method, which does the daily renaming
    # in a multi-process aware fashion (should be called only once per day per log).
    
    class <<logger
      attr_reader :logdev
    end

    logdev = logger.logdev

    # Testing rotation
    # class <<logdev
    #   attr_writer :next_rotate_time
    # end
    # logdev.next_rotate_time = Time.now + 10

    class <<logdev

      def shift_log_period(period_end)
        super
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

  def set(config)
    # Follows the pattern from the Rails generator for RAILS_LOG_TO_STDOUT
    if Rails.env.development? || Rails.env.test?
      logger = ActiveSupport::Logger.new(STDOUT)
    else
      logger = ActiveSupport::Logger.new("#{Rails.root}/log/#{@base}.log", 'daily')
      customize_rename(logger)
    end
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
  
end


end
end
