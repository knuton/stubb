require 'test/unit'

require 'second_mate'

class TestSequenceFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::SequenceFinder.new :root => 'test/fixtures'
  end

  def test_get_stalling_collection
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence', 'REQUEST_SEQUENCE_INDEX' => 1
    assert_equal ['GET collection 1'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence', 'REQUEST_SEQUENCE_INDEX' => 2
    assert_equal ['GET collection 2'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence', 'REQUEST_SEQUENCE_INDEX' => 3
    assert_equal ['GET collection 3'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence', 'REQUEST_SEQUENCE_INDEX' => 4
    assert_equal ['GET collection 3'], response.last.body
  end

  def test_get_stalling_member
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 1
    assert_equal ['GET member 1'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 2
    assert_equal ['GET member 2'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 3
    assert_equal ['GET member 3'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stalling_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 4
    assert_equal ['GET member 3'], response.last.body
  end

  def test_get_looping_collection
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence', 'REQUEST_SEQUENCE_INDEX' => 1
    assert_equal ['GET collection 0'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence', 'REQUEST_SEQUENCE_INDEX' => 2
    assert_equal ['GET collection 1'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence', 'REQUEST_SEQUENCE_INDEX' => 3
    assert_equal ['GET collection 2'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence', 'REQUEST_SEQUENCE_INDEX' => 4
    assert_equal ['GET collection 0'], response.last.body
  end

  def test_get_looping_member
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 1
    assert_equal ['GET member 0'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 2
    assert_equal ['GET member 1'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 3
    assert_equal ['GET member 2'], response.last.body
    response = @finder.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/looping_sequence/member', 'REQUEST_SEQUENCE_INDEX' => 4
    assert_equal ['GET member 0'], response.last.body
  end

end

