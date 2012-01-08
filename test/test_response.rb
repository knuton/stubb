require 'test/unit'

require 'second_mate'

class TestResponse < Test::Unit::TestCase

  def setup
    @response = SecondMate::Response.new(
      "---\nstatus: 201\nheader:\n  Foo: Baz\n---\nBody",
      {},
      200,
      {'Foo' => 'Bar'}
    )
  end

  def test_yaml_frontmatter
    response = @response.finish
    assert_equal ['Body'], response.last.body
    assert_equal 'Baz', response[1]['Foo']
  end

end

