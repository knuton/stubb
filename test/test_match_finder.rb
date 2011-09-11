require 'test/unit'

require 'second_mate'

class TestMatchFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::MatchFinder.new 'test/fixtures'
  end

  def test_matching_trailing_member
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/matching/member'
    assert_equal 200, response.first
    assert_equal ['GET matching member'], response.last.body
  end

  def test_matching_trailing_collection
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/matching/collection'
    assert_equal 200, response.first
    assert_equal ['GET matching collection'], response.last.body
  end
end
