require 'test/unit'

require 'second_mate'

class TestSequenceMatchFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::SequenceMatchFinder.new :root => 'test/fixtures'
  end

  def test_get_matched_stalling_collection
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 1)
    assert_equal ['GET matching collection 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 2)
    assert_equal ['GET matching collection 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 3)
    assert_equal ['GET matching collection 3'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 4)
    assert_equal ['GET matching collection 3'], response.last.body
  end

  def test_get_matched_stalling_member
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 1)
    assert_equal ['GET matching member 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 2)
    assert_equal ['GET matching member 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 3)
    assert_equal ['GET matching member 3'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/stalling/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 4)
    assert_equal ['GET matching member 3'], response.last.body
  end

  def test_get_matched_looping_collection
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 1)
    assert_equal ['GET matching collection 0'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 2)
    assert_equal ['GET matching collection 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 3)
    assert_equal ['GET matching collection 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 4)
    assert_equal ['GET matching collection 0'], response.last.body
  end

  def test_get_matched_looping_member
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 1)
    assert_equal ['GET matching member 0'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 2)
    assert_equal ['GET matching member 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 3)
    assert_equal ['GET matching member 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/matching/sequences/dynamic/looping/member', 'REQUEST_METHOD' => 'GET', 'REQUEST_SEQUENCE_INDEX' => 4)
    assert_equal ['GET matching member 0'], response.last.body
  end

end

