module ActionView #:nodoc:
  module Helpers #:nodoc:
    module FormTagHelper
      # Creates a label tag. Accepts a block.
      #
      # ==== Options
      # * Creates standard HTML attributes for the tag.
      #
      # ==== Examples
      #   label_tag 'name'
      #   # => <label for="name">Name</label>
      #
      #   label_tag 'name', 'Your name'
      #   # => <label for="name">Your Name</label>
      #
      #   label_tag 'name', nil, :class => 'small_label'
      #   # => <label for="name" class="small_label">Name</label>
      #
      #   label_tag do
      #     '<input type="checkbox" /> Accept <a>TOS</a>'
      #   end
      #   # => <label><input type="checkbox" /> Accept <a>TOS</a></label>
      def label_tag_with_block(*args, &block)
        if block_given?
          options = args.extract_options!
          options["for"] = name = args.shift
          text = capture(&block)
          concat label_tag_without_block(name, text, options)
        else
          label_tag_without_block(*args, &block)
        end
      end

      alias_method_chain :label_tag, :block
    end

    module FormHelper #:nodoc:
      def label_with_block(object_name, *args, &block)
        if block_given?
          options = args.extract_options!
          method = args.shift
          text = capture(&block)
          concat label_without_block(object_name, method, text, options)
        else
          label_without_block(object_name, *args, &block)
        end
      end

      alias_method_chain :label, :block
    end

    class FormBuilder #:nodoc:
      def label_with_block(method, *args, &block)
        if block_given?
          options = args.extract_options!
          text = @template.capture(&block)
          @template.concat label_without_block(method, text, options)
        else
          label_without_block(method, *args)
        end
      end

      alias_method_chain :label, :block
    end
  end
end
