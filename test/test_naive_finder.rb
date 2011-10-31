require 'test/unit'

require 'second_mate'

class TestNaiveFinder < Test::Unit::TestCase

  attr_reader :defaults

  def setup
    @finder = SecondMate::NaiveFinder.new :root => 'test/fixtures'
    # TODO properly stub this
    fake_stream = ''
    def fake_stream.read
      ''
    end
    def fake_stream.rewind
    end
    @defaults = {
      'rack.input' => fake_stream
    }
  end

  def test_get_collection
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection'
    )
    assert_equal 200, response.first
    assert_equal ['GET collection'], response.last.body
  end

  def test_get_collection_as_json_explicitly
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection.json'
    )
    assert_equal 200, response.first
    assert_equal ['GET collection.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_get_collection_as_json_implicitly
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection', 'HTTP_ACCEPT' => 'application/json, text/html'
    )
    assert_equal 200, response.first
    assert_equal ['GET collection.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_post_collection
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'POST', 'PATH_INFO' => '/collection'
    )
    assert_equal 200, response.first
    assert_equal ['POST collection'], response.last.body
  end

  def test_get_member
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection/member'
    )
    assert_equal 200, response.first
    assert_equal ['GET member'], response.last.body
  end

  def test_get_member_as_json_explicitly
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection/member.json'
    )
    assert_equal 200, response.first
    assert_equal ['GET member.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_get_member_as_json_implicitly
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection/member', 'HTTP_ACCEPT' => 'application/json'
    )
    assert_equal 200, response.first
    assert_equal ['GET member.json'], response.last.body
    assert_equal 'application/json', response[1]['Content-Type']
  end

  def test_get_member_template
    response = @finder.call defaults.merge(
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/collection/member_template', 'QUERY_STRING' => 'name=Karl'
    )
    assert_equal 200, response.first
    assert_equal ['GET Karl'], response.last.body
  end

end

