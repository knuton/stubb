require 'test/unit'

require 'second_mate'

class TestResponse < Test::Unit::TestCase

  # 404 Message

  def test_not_found
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => 'oops',
      :request_sequence => 1
    assert r.respond[0] == 404, r.respond[0].to_s
  end

  # Getting members

  def test_get_member_from_filesystem
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/members/1',
      :request_sequence => 1
    assert r.respond[0] == 200
    assert r.respond[2] == "['member']\n"
  end

  def test_get_member_through_matching
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/members/2',
      :request_sequence => 1
    assert r.respond[0] == 200
    assert r.respond[2] == "['id':'member']\n", r.respond[2]
  end

  def test_nested_matching
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/users/5/photos/2',
      :request_sequence => 1
    assert r.respond[0] == 200, r.respond[0].to_s
    assert r.respond[2] == "{'id':'nested_member'}\n", r.respond[2]
  end

  # Getting files with extensions

  def test_get_file_with_extension
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/file.txt',
      :request_sequence => 1
    assert r.respond[0] == 200
    assert r.respond[2] == "text\n"
  end

  # HTTP Methods

  def test_post_to_collection
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'POST', :request_path => '/members',
      :request_sequence => 1
    assert r.respond[0] == 200
  end

  # Sequences

  def test_looping_sequence
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/members/',
      :request_sequence => 1
    assert r.respond[2] == "[0]\n"
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/members/',
      :request_sequence => 2
    assert r.respond[2] == "[1]\n"
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/members/',
      :request_sequence => 3
    assert r.respond[2] == "[2]\n"
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/members/',
      :request_sequence => 4
    assert r.respond[2] == "[0]\n"
  end

  def test_stalling_sequence
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/stalling/',
      :request_sequence => 1
    assert r.respond[2] == "[1]\n"
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/stalling/',
      :request_sequence => 2
    assert r.respond[2] == "[2]\n"
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/stalling/',
      :request_sequence => 3
    assert r.respond[2] == "[3]\n"
    r = SecondMate::Response.new :base_dir => 'test/fixtures',
      :request_method => 'GET', :request_path => '/stalling/',
      :request_sequence => 4
    assert r.respond[2] == "[3]\n"
  end

end

