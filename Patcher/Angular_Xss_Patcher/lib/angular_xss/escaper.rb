module AngularXss

  def self.disable(&block)
    Escaper.disable(&block)
  end


  class Escaper

    XSS_DISABLED_KEY = :_angular_xss_disabled

    #BRACE = [
    #  '\\{',
    #  '&lcub;',
    #  '&lbrace;',
    #  '&#x0*7b;',
    #  '&#0*123;',
    #]
    #DOUBLE_BRACE_REGEXP = Regexp.new("(#{BRACE.join('|')})(#{BRACE.join('|')})", Regexp::IGNORECASE)

    def self.escape(string)
      return unless string
      if disabled?
        string
      else
        string.to_s.gsub('{{'.freeze, '{{ $root.DOUBLE_LEFT_CURLY_BRACE }}'.freeze)
      end
    end

    def self.disabled?
      !!Thread.current[XSS_DISABLED_KEY]
    end

    def self.disable
      old_disabled = Thread.current[XSS_DISABLED_KEY]
      Thread.current[XSS_DISABLED_KEY] = true
      yield
    ensure
      Thread.current[XSS_DISABLED_KEY] = old_disabled
    end

  end
end
