module ActiveRecord #:nodoc:
  class Base
    class << self
      def find(*args)
        options = args.extract_options!

        relation = construct_finder_arel(options, current_scoped_methods)

        case args.first
        when :first, :last, :all
          relation.send(*args)
        else
          relation.find(*args)
        end
      end
    end
  end

  module FinderMethods #:nodoc:
    def first(*n)
      if loaded?
        @records.first(*n)
      elsif n.empty?
        limit(1).to_a[0]
      else
        limit(*n).to_a
      end
    end

    def last(*n)
      if loaded?
        @records.last(*n)
      elsif n.empty?
        reverse_order.limit(1).to_a[0]
      else
        reverse_order.limit(*n).to_a.reverse
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
            relation = @reflection.klass.send(:construct_finder_arel, options)

            case args.first
            when :first, :last, :all
              relation.send(*args)
            else
              relation.find(*args)
            end
          end
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
        if @found && !args.first.kind_of?(Hash)
          proxy_found.first(*args)
        else
          super
        end
      end

      def last(*args)
        if @found && !args.first.kind_of?(Hash)
          proxy_found.last(*args)
        else
          super
        end
      end
    end
  end
end
