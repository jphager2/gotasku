# Displays Gotasku and Ruby objects in human readable forms
class Gotasku::Display 

  # convenience method 
  def self.show(object)
    new(object).show
  end

  # initialize with an object
  def initialize(object)
    @object = object
  end

  # Displays the object correctly or says it cannot display the object
  def show
    case @object
    when ::Gotasku::Problem
      show_problem(@object)
    when ::Array
      show_list(@object)
    when ::SGF::Tree
      show_tree(@object)
    else
      puts "Sorry, I can't show that.."
    end
  end

  private
    # Gives a line
    def line
      "=" * 40
    end

    # Displays Gotasku::Problem
    def show_problem(problem)
      display =  [
        line,
        "id: #{problem.id}",
        "type: #{problem.type}",
        "rating: #{problem.rating}",
        "difficulty: #{problem.difficulty}",
       ] 
      puts display, display.first
    end

    # Displays Array 
    def show_list(list)
      list.each_with_index {|item, index| puts "#{index}...#{item}"}
    end 

    # Displays an sgf tree
    def show_tree(tree)
      Tree.new(tree).show
    end

    class Tree

      attr_reader :tree
      def initialize(tree)
        @tree   = tree
        @parent = tree.root
        @r_tree = {}
      end

      def show
        inverted_ordered_hash(r_tree_hash(tree))
      end

      def inverted_ordered_hash(h)
        h.each_with_object(Hash.new {|h, k| h[k] = []}) do |(k,v),h| 
          h[v[0]] << [v[1], k]
        end
      end
      
      def r_tree_hash(tree, p_level = 0, p_index = 0) 
        child_level = p_level + 1
        @parent.children.each_with_index do |child,i| 
          @r_tree[child] = [child_level, p_index] 
          unless child.children.none?
            @parent = child
            r_tree_hash(tree, child_level, i) 
          end
        end

        @r_tree
      end
    end
end

