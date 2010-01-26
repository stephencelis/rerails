module ActiveRecord #:nodoc:
  module FinderMethods #:nodoc:
    def first(*args)
      options = args.extract_options!
      if options.any?
        apply_finder_options(options).first(*args)
      else
        find_first(*args)
      end
    end

    def last(*args)
      options = args.extract_options!
      if options.any?
        apply_finder_options(options).last(*args)
      else
        find_last(*args)
      end
    end

    private
      def find_first(n = nil)
        if loaded?
          @records.first(n)
        elsif n.nil?
          @first ||= limit(1).to_a[0]
        else
          limit(n).to_a
        end
      end

      def find_last(n = nil)
        if loaded?
          @records.first(n)
        elsif n.nil?
          @last ||= reverse_order.limit(1).to_a[0]
        else
          reverse_order.limit(n).to_a.reverse
        end
      end
  end

  module Associations #:nodoc:
    class AssociationCollection < AssociationProxy
      def find(*args)
        options = args.extract_options!

        # If using a custom finder_sql, scan the entire collection.
        if @reflection.options[:finder_sql]
          expects_array = args.first.kind_of?(Array)
          ids           = args.flatten.compact.uniq.map { |arg| arg.to_i }

          if ids.size == 1
            id = ids.first
            record = load_target.detect { |r| id == r.id }
            expects_array ? [ record ] : record
          else
            load_target.select { |r| ids.include?(r.id) }
          end
        else
          merge_options_from_reflection!(options)
          construct_find_options!(options)

          find_scope = construct_scope[:find].slice(:conditions, :order)

          with_scope(:find => find_scope) do
            relation = @reflection.klass.send(:construct_finder_arel, options, @reflection.klass.send(:current_scoped_methods))

            case args.first
            when :first, :last
              relation.send(*args)
            when :all
              records = relation.all
              @reflection.options[:uniq] ? uniq(records) : records
            else
              relation.find(*args)
            end
          end
        end
      end

      def first(*args)
        if fetch_first_or_last_using_find?(args)
          find(:first, *args)
        else
          load_target unless loaded?
          @target.first(*args)
        end
      end

      def last(*args)
        if fetch_first_or_last_using_find?(args)
          find(:last, *args)
        else
          load_target unless loaded?
          @target.last(*args)
        end
      end

      private
        def fetch_first_or_last_using_find?(args)
          args.first.kind_of?(Hash) || !(loaded? || @owner.new_record? || @reflection.options[:finder_sql]) ||
            @target.any? { |record| record.new_record? }
        end
    end
  end

  module NamedScope #:nodoc:
    class Scope
      def first(*args)
        if loaded? && !args.first.kind_of?(Hash)
          to_a.first(*args)
        else
          options = args.extract_options!
          if options.any?
            apply_finder_options(options).first(*args)
          else
            super
          end
        end
      end

      def last(*args)
        if loaded? && !args.first.kind_of?(Hash)
          to_a.last(*args)
        else
          options = args.extract_options!
          if options.any?
            apply_finder_options(options).last(*args)
          else
            super
          end
        end
      end
    end
  end
end
