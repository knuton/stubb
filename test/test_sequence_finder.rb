require 'test/unit'

require 'stubb'

class TestSequenceFinder < Test::Unit::TestCase

  def setup
    @finder = Stubb::SequenceFinder.new :root => 'test/fixtures'
  end

  def test_get_stalling_collection
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    assert_equal ['GET collection 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 2)
    assert_equal ['GET collection 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 3)
    assert_equal ['GET collection 3'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 4)
    assert_equal ['GET collection 3'], response.last.body
  end

  def test_get_stalling_collection_as_root
    @finder = Stubb::SequenceFinder.new :root => 'test/fixtures/stalling_sequence'
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    assert_equal ['GET collection 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 2)
    assert_equal ['GET collection 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 3)
    assert_equal ['GET collection 3'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 4)
    assert_equal ['GET collection 3'], response.last.body
  end

  def test_get_stalling_member
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    assert_equal ['GET member 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 2)
    assert_equal ['GET member 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 3)
    assert_equal ['GET member 3'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 4)
    assert_equal ['GET member 3'], response.last.body
  end

  def test_get_looping_collection
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    assert_equal ['GET collection 0'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 2)
    assert_equal ['GET collection 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 3)
    assert_equal ['GET collection 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 4)
    assert_equal ['GET collection 0'], response.last.body
  end

  def test_get_looping_collection_as_root
    @finder = Stubb::SequenceFinder.new :root => 'test/fixtures/looping_sequence'
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    assert_equal ['GET collection 0'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 2)
    assert_equal ['GET collection 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 3)
    assert_equal ['GET collection 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 4)
    assert_equal ['GET collection 0'], response.last.body
  end

  def test_get_looping_member
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    puts @finder.request.sequence_index, response.last.body, @finder.send(:projected_path), @finder.send(:loop?), @finder.send(:index), @finder.send(:sm), '#'
    assert_equal ['GET member 0'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 2)
    puts @finder.request.sequence_index, response.last.body, @finder.send(:projected_path), @finder.send(:loop?), @finder.send(:index), '#'
    assert_equal ['GET member 1'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 3)
    assert_equal ['GET member 2'], response.last.body
    response = @finder.call Rack::MockRequest.env_for('/looping_sequence/member', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 4)
    assert_equal ['GET member 0'], response.last.body
  end

  def test_get_template_sequence
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence/template?name=Karl', 'REQUEST_METHOD' => 'GET', 'stubb.request_sequence_index' => 1)
    assert_equal 200, response.first
    assert_equal ['GET Karl 1'], response.last.body
  end

  def test_post_template_sequence
    response = @finder.call Rack::MockRequest.env_for('/stalling_sequence/template', 'REQUEST_METHOD' => 'POST', 'stubb.request_sequence_index' => 1, :input => 'name=Karl')
    assert_equal 200, response.first
    assert_equal ['POST Karl 1'], response.last.body
  end

end

