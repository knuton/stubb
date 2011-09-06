require 'test/unit'

require 'second_mate'

class TestCounter < Test::Unit::TestCase

  def setup
    @env = { 'PATH_INFO' => '/request/path' }
    @counter = SecondMate::Counter.new lambda { |env| [200, {}, [env['REQUEST_SEQUENCE_INDEX']]] }
  end

  def test_initial_request
    result = @counter.call(@env)
    assert_equal 1, @env['REQUEST_SEQUENCE_INDEX']
    assert_equal result.last.last, @env['REQUEST_SEQUENCE_INDEX']
  end

  def test_repeated_request
    @counter.call(@env)
    result = @counter.call(@env)
    assert_equal 2, result.last.last
  end

  def test_side_effects
    @counter.call(@env)
    result = @counter.call({ 'PATH_INFO' => '/request/other' })
    assert_equal 1, result.last.last
  end

end

