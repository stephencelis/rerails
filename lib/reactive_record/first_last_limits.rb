module ActiveRecord #:nodoc:
  class Base
    class << self
      # A convenience wrapper for <tt>find(:first, *args)</tt>. You can pass in
      # all the same arguments to this method as you can to
      # <tt>find(:first)</tt>. The limit can be passed in directly as the
      # first argument.
      #
      # ==== Examples
      #
      #   Post.first
      #   # => #<Post id: 1, posted: false>
      #   Post.first(2, :conditions => { :posted => true })
      #   # => [#<Post id: 2, posted: true>, #<Post id: 3, posted: true>]
      def first(*args)
        options, limit = args.extract_options!, args.shift
        find(:first, *(args << options.merge(:limit => limit || options[:limit])))
      end

      # A convenience wrapper for <tt>find(:last, *args)</tt>. You can pass in
      # all the same arguments to this method as you can to
      # <tt>find(:last)</tt>. The limit can be passed in directly as the
      # first argument.
      #
      # ==== Examples
      #
      #   Post.last
      #   # => #<Post id: 50, posted: false>
      #   Post.last(2, :conditions => { :posted => true })
      #   # => [#<Post id: 48, posted: true>, #<Post id: 49, posted: true>]
      def last(*args)
        options, limit = args.extract_options!, args.shift
        find(:last, *(args << options.merge(:limit => limit || options[:limit])))
      end

      private
        def find_initial(options)
          every = find_every(options.merge(:limit => options[:limit] || 1))
          options[:limit] ? every : every.first
        end

        def find_last_with_limit(options)
          last = find_last_without_limit(options)
          options[:limit] ? last.reverse : last
        end
        alias_method_chain :find_last, :limit
    end
  end

  module Associations #:nodoc:
    class AssociationCollection < AssociationProxy
      # Fetches the first n records (default: 1) using SQL if possible.
      def first(*args)
        if fetch_first_or_last_using_find?(args)
          options, limit = args.extract_options!, args.shift
          find(:first, *(args << options.merge(:limit => limit || options[:limit])))
        else
          load_target unless loaded?
          @target.first(*args)
        end
      end

      # Fetches the last n records (default: 1) using SQL if possible.
      def last(*args)
        if fetch_first_or_last_using_find?(args)
          options, limit = args.extract_options!, args.shift
          find(:last, *(args << options.merge(:limit => limit || options[:limit])))
        else
          load_target unless loaded?
          @target.last(*args)
        end
      end

      private
        def fetch_first_or_last_using_find?(args)
          !(loaded? || @owner.new_record? || @reflection.options[:finder_sql]) ||
            @target.any? { |record| record.new_record? }
        end
    end
  end

  module NamedScope #:nodoc:
    class Scope
      def first(*args)
        if @found
          proxy_found.first(*args)
        else
          super
        end
      end

      def last(*args)
        if @found
          proxy_found.last(*args)
        else
          super
        end
      end
    end
  end
end
