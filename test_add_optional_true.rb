require "minitest/autorun"
require_relative "add_optional_true"

class TestAddOptionalTrue < Minitest::Test
  SAMPLE = <<~EOF
  class Sample
    belongs_to :user
    belongs_to :company, required: false
    belongs_to :parent, optional: true
    belongs_to :organization
  end
EOF

  EXPECTED = <<~EOF
  class Sample
    belongs_to :user, optional: true
    belongs_to :company, required: false
    belongs_to :parent, optional: true
    belongs_to :organization, optional: true
  end
EOF

  def test_add_optional_true
    buffer = Parser::Source::Buffer.new('(example)')
    buffer.source = SAMPLE
    rewriter = AddOptionalTrue.new
    rewritten = rewriter.rewrite(buffer, Parser::CurrentRuby.parse(buffer.source))
    assert_equal EXPECTED, rewritten
  end
end
