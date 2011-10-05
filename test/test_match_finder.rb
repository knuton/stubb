require 'test/unit'

require 'second_mate'

class TestMatchFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::MatchFinder.new :root => 'test/fixtures'
  end

  def test_trailing_matching_member
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/matching/collection/dynamic'
    assert_equal 200, response.first
    assert_equal ['GET matching member'], response.last.body
  end

  def test_trailing_matching_collection
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/matching/dynamic'
    assert_equal 200, response.first
    assert_equal ['GET matching collection'], response.last.body
  end

  def test_embedded_matching_collection
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/matching/dynamic/static'
    assert_equal 200, response.first
    assert_equal ['GET static'], response.last.body
  end

end
