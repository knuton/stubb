require 'test/unit'

require 'second_mate'

class TestNaiveFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::NaiveFinder.new 'test/fixtures'
  end

  def test_get_collection
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection'
    assert_equal 200, response.first
    assert_equal ['GET collection'], response.last.body
  end

  def test_post_collection
    response = @finder.call 'REQUEST_METHOD' => 'POST', 'PATH_INFO' => '/collection'
    assert_equal 200, response.first
    assert_equal ['POST collection'], response.last.body
  end

  def test_get_member
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection/member'
    assert_equal 200, response.first
    assert_equal ['GET member'], response.last.body
  end

end

