require 'test/unit'

require 'second_mate'

class TestMatchFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::MatchFinder.new :root => 'test/fixtures'
  end

  def test_trailing_matching_collection
    response = @finder.call Rack::MockRequest.env_for('/matching/dynamic', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET matching collection'], response.last.body
  end

  def test_trailing_matching_collection_as_json_explicitly
    response = @finder.call Rack::MockRequest.env_for('/matching/dynamic.json', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET matching collection.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_trailing_matching_collection_as_json_implicitly
    response = @finder.call Rack::MockRequest.env_for('/matching/dynamic', 'REQUEST_METHOD' => 'GET', 'HTTP_ACCEPT' => 'application/json')
    assert_equal 200, response.first
    assert_equal ['GET matching collection.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_embedded_matching_collection
    response = @finder.call Rack::MockRequest.env_for('/matching/dynamic/static', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET static'], response.last.body
  end

  def test_embedded_matching_collection_as_json_explicitly
    response = @finder.call Rack::MockRequest.env_for('/matching/dynamic/static.json', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET static.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_trailing_matching_collection_as_json_implicitly
    response = @finder.call Rack::MockRequest.env_for('/matching/dynamic/static', 'REQUEST_METHOD' => 'GET', 'HTTP_ACCEPT' => 'application/json')
    assert_equal 200, response.first
    assert_equal ['GET static.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_trailing_matching_member
    response = @finder.call Rack::MockRequest.env_for('/matching/collection/dynamic', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET matching member'], response.last.body
  end

  def test_trailing_matching_member_as_json_explicitly
    response = @finder.call Rack::MockRequest.env_for('/matching/collection/dynamic.json', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET matching member.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_trailing_matching_member_as_json_implicitly
    response = @finder.call Rack::MockRequest.env_for('/matching/collection/dynamic.json', 'REQUEST_METHOD' => 'GET', 'HTTP_ACCEPT' => 'application/json')
    assert_equal 200, response.first
    assert_equal ['GET matching member.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

end
