require 'parser/current'
require 'set'
Parser::Builders::Default.emit_lambda              = true
Parser::Builders::Default.emit_procarg0            = true
Parser::Builders::Default.emit_encoding            = true
Parser::Builders::Default.emit_index               = true
Parser::Builders::Default.emit_arg_inside_procarg0 = true
Parser::Builders::Default.emit_forward_arg         = true
Parser::Builders::Default.emit_kwargs              = true
Parser::Builders::Default.emit_match_pattern       = true

class AddOptionalTrueForShouldaMatchers < Parser::TreeRewriter
  def initialize
    super
    @processed_chains = Set.new
  end

  def on_send(node)
    # Only process chains that contain belong_to and haven't been processed yet
    if contains_belong_to?(node) && !@processed_chains.include?(node.object_id)
      # Mark entire chain as processed to avoid duplicate processing
      mark_chain_processed(node)

      # Check if chain already has optional or required
      unless has_optional_or_required?(node)
        # Add .optional at the end of the chain
        insert_after(node.loc.expression, '.optional')
      end
    end

    super
  end

  private

  def contains_belong_to?(node)
    return false unless node.is_a?(Parser::AST::Node) && node.type == :send

    receiver, method_name = *node
    return true if method_name == :belong_to

    contains_belong_to?(receiver)
  end

  def has_optional_or_required?(node)
    return false unless node.is_a?(Parser::AST::Node) && node.type == :send

    receiver, method_name = *node
    return true if method_name == :optional || method_name == :required

    has_optional_or_required?(receiver)
  end

  def mark_chain_processed(node)
    return unless node.is_a?(Parser::AST::Node) && node.type == :send

    @processed_chains.add(node.object_id)
    receiver = node.children[0]
    mark_chain_processed(receiver)
  end
end
