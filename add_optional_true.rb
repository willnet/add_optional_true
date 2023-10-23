require 'parser/current'
Parser::Builders::Default.emit_lambda              = true
Parser::Builders::Default.emit_procarg0            = true
Parser::Builders::Default.emit_encoding            = true
Parser::Builders::Default.emit_index               = true
Parser::Builders::Default.emit_arg_inside_procarg0 = true
Parser::Builders::Default.emit_forward_arg         = true
Parser::Builders::Default.emit_kwargs              = true
Parser::Builders::Default.emit_match_pattern       = true

class AddOptionalTrue < Parser::TreeRewriter
  def on_send(node)
    if node.children[1] == :belongs_to && !optional_or_required_is_defined?(node)
      insert_after(node.loc.expression, ', optional: true')
    end
    super
  end

  def optional_or_required_is_defined?(node)
    node.children[3..].any? do |child|
      next false unless child.type == :kwargs

      child.children.any? do |gchild|
        gchild.type == :pair && (gchild.children[0].children[0] == :optional || gchild.children[0].children[0] == :required)
      end
    end
  end
end
