require 'test/unit'

require 'second_mate'

class TestNaiveFinder < Test::Unit::TestCase

  def setup
    @finder = SecondMate::NaiveFinder.new :root => 'test/fixtures'
  end

  def test_get_collection
    response = @finder.call Rack::MockRequest.env_for('/collection', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET collection'], response.last.body
  end

  def test_get_collection_as_json_explicitly
    response = @finder.call Rack::MockRequest.env_for('/collection.json', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET collection.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_get_collection_as_json_implicitly
    response = @finder.call Rack::MockRequest.env_for('/collection', 'REQUEST_METHOD' => 'GET', 'HTTP_ACCEPT' => 'application/json, text/html')
    assert_equal 200, response.first
    assert_equal ['GET collection.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_post_collection
    response = @finder.call Rack::MockRequest.env_for('/collection', 'REQUEST_METHOD' => 'POST')
    assert_equal 200, response.first
    assert_equal ['POST collection'], response.last.body
  end

  def test_get_member
    response = @finder.call Rack::MockRequest.env_for('/collection/member', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET member'], response.last.body
  end

  def test_get_member_as_json_explicitly
    response = @finder.call Rack::MockRequest.env_for('/collection/member.json', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET member.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_get_member_as_json_implicitly
    response = @finder.call Rack::MockRequest.env_for('/collection/member', 'REQUEST_METHOD' => 'GET', 'HTTP_ACCEPT' => 'application/json')
    assert_equal 200, response.first
    assert_equal ['GET member.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_get_member_template
    response = @finder.call Rack::MockRequest.env_for('/collection/member_template?name=Karl', 'REQUEST_METHOD' => 'GET')
    assert_equal 200, response.first
    assert_equal ['GET Karl'], response.last.body
  end

end

