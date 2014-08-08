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

      attr_accessor :tree, :parent, :parent_level, :parent_index, :r_tree
      def initialize(tree)
        @tree   = tree
        @parent_level = 0
        @parent_index = 0
        @parent = @tree.root
        @r_tree = {
          @tree.root => {
            child_level:  0,
            parent_index: 0, 
          }
        }
      end

      def show
        @html ||= html_head +
                  html(inverted_ordered_hash(r_tree_hash)) +
                  html_foot
      end

      def html_head
        <<-HTML
        <html>
          <head>
            <title>Tree #{@tree.object_id}</title>
            <style></style>
          </head>
          <body>
        HTML
      end

      def html(hash)
        <<-HTML
            <div id="tree"></div>
        HTML
      end

      def html_foot
        <<-HTML
          </body>
        </html>
        HTML
      end

      def inverted_ordered_hash(h)
        h.each_with_object(Hash.new {|h, k| h[k] = []}) do |(k,v),h| 
          h[v[:child_level]] << [v[:parent_index], k]
        end
      end
      
      def r_tree_hash
        child_level = parent_level + 1
        parent.children.each_with_index do |child,i| 
          r_tree[child] = {
            child_level:  child_level, 
            parent_index: parent_index, 
          }
          unless child.children.none?
            parent, parent_level, parent_index = child, child_level, i
            r_tree_hash
          end
        end

        r_tree
      end
    end
end

