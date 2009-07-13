require 'rubygems'
require 'init'
require 'test/unit'

class Test::Unit::TestCase
  def assert_field(field, value)
    clean_backtrace do 
      assert_equal value, @helper.fields[field]
    end
  end

  private
  def clean_backtrace(&block)
    yield
  rescue Test::Unit::AssertionFailedError => e
    path = File.expand_path(__FILE__)
    raise Test::Unit::AssertionFailedError, e.message, e.backtrace.reject { |line| File.expand_path(line) =~ /#{path}/ }
  end
end