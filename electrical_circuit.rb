class CircuitFinder

  attr_accessor :elements, :first_nodes, :last_nodes, :circuits

  def initialize(nodes)
    @elements = nodes.collect { |node| Node.new(node) }
    @first_nodes = get_first_nodes(elements[0])
    @last_nodes = get_last_nodes(elements[-1])

    @elements.each do |element|
      element.neighbours = find_neighbours_for(element)
    end

  end

  def circuit

    current_node = first_nodes[0]
    path = Circuit.new(current_node)

    elements.each do |element|
      begin
        if element.child_of?(current_node)
          path.add_node(element)
          current_node = current_node.neighbours[0]
        end
      end unless last_nodes.include?(current_node)
    end

    path
  end

  def find_neighbours_for(node)

    elements.find_all do |element|
      node.parent_of?(element)
    end

  end

  def get_first_nodes(node)
    elements.select do |element|
      node.start == element.start
    end
  end

  def get_last_nodes(node)
    elements.select do |element|
      node.finish == element.finish
    end
  end

# helpers for debugging
  def output_all_neighbours
    elements.each do |element|
      puts "Neighbours for element: #{element.to_s} : "
      element.neighbours.each do |neighbour|
        puts " --- "
        puts neighbour.to_s
      end
      puts "\n ===================== \n"

    end
  end

end


class Circuit

  attr_accessor :path
  @@list = []

  def initialize(path)
    @@list << self
    @path = [path]
  end

  def add_node(node)
    self.path.push(node)
  end

  def cost
    path.inject(0) do |sum, var|
      sum + var.cost
    end
  end

  # class methods
  def self.list
    @@list
  end

end


class Node
  attr_accessor :start, :finish, :cost, :neighbours

  def initialize(point = [])
    @start = point[0]
    @finish = point[1]
    @cost = point[2]
  end

  def parent_of?(node)
    finish == node.start
  end


  def child_of?(node)
    start == node.finish
  end

  def to_s
    [start, finish, cost].to_s
  end

end


#TODO Create every single available circuit, compare costs and keep the lowest.



# Program start

elements = [
  [:A, :B, 50],
  [:A, :D, 150],
  [:B, :C, 250],
  [:B, :E, 250],
  [:C, :E, 350],
  [:C, :D, 50],
  [:C, :F, 100],
  [:D, :F, 400],
  [:E, :G, 200],
  [:F, :G, 100],
]

cf = CircuitFinder.new(elements)
cf.output_all_neighbours
puts cf.circuit.path
puts cf.circuit.cost
puts Circuit.list
