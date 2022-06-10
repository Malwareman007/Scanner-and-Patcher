shared_examples_for 'engine preventing Angular XSS' do |partial:|

  let(:path_set) { ActionView::LookupContext.new([TEMPLATE_ROOT]) }

  if defined?(ActionView::VERSION) && ActionView::VERSION::MAJOR >= 6
    let(:engine) { ActionView::Base.with_empty_template_cache.new(path_set, {}, nil) }
  else
    let(:engine) { ActionView::Base.new(path_set) }
  end

  let(:html) { engine.render(partial) }

  it 'escapes Angular interpolation marks in unsafe strings' do
    html.should_not include('{{unsafe}}')
    html.should include('{{ $root.DOUBLE_LEFT_CURLY_BRACE }}unsafe}}')
  end

  it 'recognizes the many ways to express an opening curly brace in HTML' do

    html.should include("{{ $root.DOUBLE_LEFT_CURLY_BRACE }}unsafe}}")
    html.should_not include("{{unsafe}}")

    braces = [
     '{',
     '&lcub;',
     '&lbrace;',
     '&#x7b;',
     '&#X7B;',
     '&#x000007b;',
     '&#x000000000007b;',
     '&#123;',
     '&#000000123;',
     '&#0000000000000123;'
    ]

    braces.each do |brace1|
      braces.each do |brace2|
        html.should_not include("#{brace1}#{brace2}unsafe}}")
      end
    end

  end

  it 'does not escape Angular interpolation marks in safe strings' do
    html.should include("{{safe}}")
    html.should_not include("{{ $root.DOUBLE_LEFT_CURLY_BRACE }}safe}}")
  end

  it 'does not escape Angular interpolation marks in a block where AngularXSS is disabled' do
    result = nil
    AngularXss.disable do
      result = html
    end

    result.should include('{{unsafe}}')
    result.should_not include('{{ $root.DOUBLE_LEFT_CURLY_BRACE }}unsafe}}')
  end

  it 'does escape Angular interpolation marks after the block where AngularXSS is disabled' do
    AngularXss.disable do
    end
    result = html

    result.should include('{{ $root.DOUBLE_LEFT_CURLY_BRACE }}unsafe}}')
    result.should_not include('{{unsafe}}')
  end

  it 'is not confused by exceptions in disable blocks' do
    class SomeException < StandardError; end

    proc {
      AngularXss.disable do
        raise SomeException
      end
    }.should raise_error(SomeException)

    html.should include('{{ $root.DOUBLE_LEFT_CURLY_BRACE }}unsafe}}')
    html.should_not include('{{unsafe}}')
  end

  it 'does not escape twice' do
    escaped = AngularXss::Escaper.escape('{{')
    double_escaped = AngularXss::Escaper.escape(escaped)
    html.should_not include(double_escaped)
  end

end
