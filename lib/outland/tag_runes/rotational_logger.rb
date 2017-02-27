module Outland
module TagRunes


class RotationalLogger
  
  def self.set(config)
    logger = if Rails.env.development? || Rails.env.test?
      ActiveSupport::Logger.new(STDOUT)
    else
      ActiveSupport::Logger.new("#{Rails.root}/log/rails.log", 'daily')
    end
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
  
end


end
end
