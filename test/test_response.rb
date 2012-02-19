require 'test/unit'

require 'stubb'

class TestResponse < Test::Unit::TestCase

  def test_yaml_frontmatter
    response = Stubb::Response.new(
      "---\nstatus: 201\nheader:\n  Foo: Baz\n---\nBody",
      {},
      200,
      {'Foo' => 'Bar'}
    ).finish
    assert_equal ['Body'], response.last.body
    assert_equal 'Baz', response[1]['Foo']
  end

  def test_templating
    response = Stubb::Response.new(
      "<%= params['foo'] %>",
      {'foo' => 'Bar'},
      200,
      {}
    ).finish
    assert_equal ['Bar'], response.last.body
  end

end

