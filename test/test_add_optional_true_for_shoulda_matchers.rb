require "minitest/autorun"
require_relative "../lib/add_optional_true_for_shoulda_matchers"

class TestAddOptionalTrueForShouldaMatchers < Minitest::Test
  SAMPLE = <<~RUBY
    RSpec.describe Sample do
      it { is_expected.to belong_to(:user).class_name("User") }
      it { is_expected.to belong_to(:company).class_name("Company").required }
      it { is_expected.to belong_to(:parent).class_name("Parent").optional }
      it { is_expected.to belong_to(:organization).required }
      it { is_expected.to belong_to(:book).optional }
      it { is_expected.to belong_to(:team) }
    end
  RUBY

  EXPECTED = <<~RUBY
    RSpec.describe Sample do
      it { is_expected.to belong_to(:user).class_name("User").optional }
      it { is_expected.to belong_to(:company).class_name("Company").required }
      it { is_expected.to belong_to(:parent).class_name("Parent").optional }
      it { is_expected.to belong_to(:organization).required }
      it { is_expected.to belong_to(:book).optional }
      it { is_expected.to belong_to(:team).optional }
    end
  RUBY

  def test_add_optional_true_for_shoulda_matchers
    buffer = Parser::Source::Buffer.new('(example)')
    buffer.source = SAMPLE
    rewriter = AddOptionalTrueForShouldaMatchers.new
    ast = Parser::CurrentRuby.parse(buffer.source)
    rewritten = rewriter.rewrite(buffer, ast)
    assert_equal EXPECTED, rewritten
  end
end
