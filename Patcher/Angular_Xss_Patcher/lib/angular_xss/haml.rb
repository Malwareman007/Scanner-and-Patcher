# Haml 5.0 and 5.1 fall back to erb
if Haml::VERSION < '5'
  # Use module_eval so we crash when Haml::Helpers has not yet been loaded.
  Haml::Helpers.module_eval do

    def html_escape_with_escaping_angular_expressions(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        html_escape_without_escaping_angular_expressions(AngularXss::Escaper.escape(s))
      end
    end

    alias_method :html_escape_without_escaping_angular_expressions, :html_escape
    alias_method :html_escape, :html_escape_with_escaping_angular_expressions
  end

elsif Haml::VERSION >= '5.2' 
  Haml::Helpers.module_eval do

    def html_escape_without_haml_xss_with_escaping_angular_expressions(s)
      s = s.to_s
      return s if s.html_safe?

      html_escape_without_haml_xss_without_escaping_angular_expressions(AngularXss::Escaper.escape(s))
    end

    alias_method :html_escape_without_haml_xss_without_escaping_angular_expressions, :html_escape_without_haml_xss
    alias_method :html_escape_without_haml_xss, :html_escape_without_haml_xss_with_escaping_angular_expressions
  end
end
