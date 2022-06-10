ActionView::Template.class_eval do

  protected

  def compile_with_angular_xss(*args, &block)
    AngularXss.disable do
      compile_without_angular_xss(*args, &block)
    end
  end

  alias_method :compile_without_angular_xss, :compile
  alias_method :compile, :compile_with_angular_xss

end
