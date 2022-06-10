# Use module_eval so we crash when ERB::Util has not yet been loaded.
ERB::Util.module_eval do

  if private_method_defined? :unwrapped_html_escape # Rails 4.2+

    def unwrapped_html_escape_with_escaping_angular_expressions(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        unwrapped_html_escape_without_escaping_angular_expressions(AngularXss::Escaper.escape(s))
      end
    end

    alias_method :unwrapped_html_escape_without_escaping_angular_expressions, :unwrapped_html_escape
    alias_method :unwrapped_html_escape, :unwrapped_html_escape_with_escaping_angular_expressions

    singleton_class.send(:remove_method, :unwrapped_html_escape)
    module_function :unwrapped_html_escape
    module_function :unwrapped_html_escape_without_escaping_angular_expressions

  else # Rails < 4.2

    def html_escape_with_escaping_angular_expressions(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        html_escape_without_escaping_angular_expressions(AngularXss::Escaper.escape(s))
      end
    end

    alias_method_chain :html_escape, :escaping_angular_expressions

    # Aliasing twice issues a warning "discarding old...". Remove first to avoid it.
    remove_method(:h)
    alias h html_escape

    module_function :h

    singleton_class.send(:remove_method, :html_escape)
    module_function :html_escape
    module_function :html_escape_without_escaping_angular_expressions

  end

end
