require 'test/unit'

require 'second_mate'

class TestRequest < Test::Unit::TestCase

  def setup
    @request = SecondMate::Request.new 'PATH_INFO' => '/test/the/functionality.html.erb'
  end

  def test_path_parts
    assert_equal ['test', 'the', 'functionality.html.erb'], @request.path_parts
  end

  def test_path_dir_parts
    assert_equal ['test', 'the'], @request.path_dir_parts
  end

  def test_file_name
    assert_equal 'functionality.html.erb', @request.file_name
  end

  def test_resource_name
    assert_equal 'functionality.html', @request.resource_name
  end

  def test_extension
    assert_equal '.erb', @request.extension
  end

  def test_relative_path
    assert_equal 'test/the/functionality.html.erb', @request.relative_path
  end

end

