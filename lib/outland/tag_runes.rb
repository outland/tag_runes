require 'outland/tag_runes/custom_log_renamer'
require 'outland/tag_runes/rotational_logger'
require 'outland/tag_runes/version'

module Outland
module TagRunes

  # These glyphs should be chosen to maximize visual distinctiveness
  # while being available in terminal fonts.
  
  GLYPHS = %w(
    a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 6 7 8 9 ᚠ ÿ
    À Á ᚢ Ã Ä Å Æ Ç È ᚣ Ê Ë Ì Í Î Ï Ð Ñ Ò Ó ᚧ Õ Ö × Ø Ù Ú Û Ü ᛗ ᚸ ᛉ
    Ý Þ ß à á â ã ä å æ ç è é ê ë ì í î ï ð ñ ò ó ô õ ö ÷ ø ù ú û ü
    ΐ § ¶ Γ Δ © ® ¥ Θ £ ¿ Λ « » Ξ ± Π ¤ Σ ¢ ¡ Φ ° Ψ Ω Ϊ Ϋ ά έ ή ί ΰ
    α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ ς σ τ υ φ χ ψ ω ϊ ϋ ό ύ ώ ϐ ϑ
    ϒ ϓ ϔ ϕ ϖ ϗ Ϙ ϙ Ϛ ϛ Ϝ ϝ Ϟ ϟ Ϡ ϡ Ϣ ϣ Ϥ ϥ Ϧ ϧ Ϩ ϩ Ϫ ϫ Ϭ ϭ Ϯ ϯ ϰ ϱ
    ♥ Б ♦ ♠ Д ♣ Ж ★ И Й ☉ Л ☇ ☈ ☃ П ☂ ☀ ᛉ ☆ Ф ᛰ Ц Ч Ш Щ Ъ Ы ☥ Э Ю Я
  )
  

  def self.sign(hex)
    hex.scan(/\h\h/).map do |b|
      GLYPHS[b.to_i(16)]
    end.join
  end
  
  def self.signature(sid, rid)
    "#{sid ? sign(sid[0,8]) : '____'} #{sign(rid[0,4])}"
  end
  
  # At this point in the middleware, we don't have access to the session.
  # A good approximation is the passed-up session id, although it's
  # controlled by the client.  We 'sign' it with a compressed visual
  # representation that doesn't clutter up the log too badly and is still
  # highly likely to be unique when used for debugging expeditions into
  # the log.
  #
  # An abbreviated signature of the request id is added as well, to aid
  # in understanding interleaved log entries.
  
  def self.rails_tag
    Proc.new do |req|
      # Set the tag in the rack environment so it can be picked up by
      # tools like Airbrake.
      sess_id = req.cookies[Rails.application.config.session_options[:key]]
      req.env['request_tag'] = signature(sess_id, req.uuid)
    end
  end


  # ensure tags appear on each line of a multiline log statement.
  module MultilineFormatter

    def call(severity, timestamp, progname, msg)
      if msg && msg.index("\n")
        msg.lines.map{|l| super(severity, timestamp, progname, l.chomp)}.join
      else
        super
      end
    end
    
  end


  # Hook Rails init process
  class Railtie < Rails::Railtie
    initializer 'outland-tag_runes' do |app|

      Rails.logger.formatter.extend MultilineFormatter

      # Keep requests separated when deployed for sanity's sake
      unless Rails.env.development?
        ActiveSupport::Notifications.subscribe('process_action.action_controller') do |_|
          Rails.logger.info "\n\n"
        end
      end

    end
  end

end
end
