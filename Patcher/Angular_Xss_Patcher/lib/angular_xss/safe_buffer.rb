##
# Monkey patch ActiveSupport::SafeBuffer to escape double braces from Angular
#
# Link to the original implementation without Angular XSS escaping:
# https://github.com/rails/rails/blob/7-0-stable/activesupport/lib/active_support/core_ext/string/output_safety.rb#L295
#
ActiveSupport::SafeBuffer.class_eval do

  html_escape = :html_escape_interpolated_argument

  if private_method_defined?(html_escape) || # Rails < 6.1
    private_method_defined?(:"explicit_#{html_escape}") # Rails >= 6.1

    private

    def explicit_html_escape_interpolated_argument_with_angular_xss(arg)
      if !html_safe? || arg.html_safe?
        arg
      else
        explicit_html_escape_interpolated_argument_without_angular_xss(AngularXss::Escaper.escape(arg))
      end
    end

    if private_method_defined?(html_escape)
      alias_method :"explicit_#{html_escape}_without_angular_xss", html_escape
      alias_method html_escape, :"explicit_#{html_escape}_with_angular_xss"
    elsif private_method_defined?(:"explicit_#{html_escape}")
      alias_method :"explicit_#{html_escape}_without_angular_xss", :"explicit_#{html_escape}"
      alias_method :"explicit_#{html_escape}", :"explicit_#{html_escape}_with_angular_xss"
    end

    if private_method_defined?(:"implicit_#{html_escape}")
      def implicit_html_escape_interpolated_argument_with_angular_xss(arg)
        if !html_safe? || arg.html_safe?
          arg
        else
          implicit_html_escape_interpolated_argument_without_angular_xss(AngularXss::Escaper.escape(arg))
        end
      end
      alias_method :"implicit_#{html_escape}_without_angular_xss", :"implicit_#{html_escape}"
      alias_method :"implicit_#{html_escape}", :"implicit_#{html_escape}_with_angular_xss"
    end
  end
end
