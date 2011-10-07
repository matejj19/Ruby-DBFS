# D.cv. MI-RUB 01 - BFS/DFS
# Jan Mateju, matejj19

# Trida predstavujici uzel grafu
class Node

  @id
  @successors
  @state

  def initialize(id)
    @id = id
    @successors = Array.new
    @state = :fresh
  end

  attr_reader :id
  attr_accessor :state

  def add_successor(node)
    @successors.push(node)
  end

  def get_successors
    @successors
  end

  def to_s
    print "Node@#{@id};successors:["
    @successors.each { |node| print "(#{node.id})" }
    print "];state:#{@state}\n"
  end

end


#Trida predstavujici graf
class Graph

  @id
  @nodes
  @tasks

  def initialize(id)
    @id = id
    @nodes = Hash.new
    @tasks = Array.new
  end

  attr_reader :id

  def add_node(node)
    @nodes.store(node.id, node)
  end

  def get_node(id)
    @nodes.fetch(id)
  end

  def refresh_nodes
    @nodes.each_value { |node| node.state = :fresh }
  end

  def add_task(task)
    @tasks.push(task)
  end

  def get_tasks
    @tasks
  end

  def to_s
    print "Graph@#{@id};nodes:#{@nodes.keys};tasks:["
    @tasks.each { |task| print "(#{task.start},#{task.pass})" }
    print "]\n"
  end

end

#Trida predstavujici ukol
class Task

  @start
  @pass

  def initialize(start, pass)
    @start = start
    @pass = pass
  end

  attr_reader :start, :pass

end

#Main
class Main

  @@graphs = Array.new

  public

  #nacteni grafu
  def self.read_graphs
    #nacteme pocet grafu
    @@graphs = Array.new(STDIN.gets.to_i)

    id = 0
    for graph in graphs
      graph = Graph.new(id+1)
      @@graphs[id] = graph
      id += 1

      #nacteme pocet uzlu a uzly vytvorime
      pocet_uzlu = STDIN.gets.to_i
      for i in 1..pocet_uzlu
        graph.add_node(Node.new(i))
      end

      #nacteme sousedy uzlu
      for p in 1..pocet_uzlu
        #pridame uzlu sousedy
        tokens = STDIN.gets.scan(/\w+/)
        node = graph.get_node(p)

        for k in 2..(tokens[1].to_i + 1)
          node.add_successor(graph.get_node(tokens[k].to_i))
        end
      end

      #nacteme ulohy
      while true
        tokens = STDIN.gets.scan(/\w+/)
        if (tokens[0].to_i).equal?(0)
          break
        elsif (tokens[1].to_i).equal?(0)
          graph.add_task(Task.new(tokens[0].to_i, :dfs))
        else
          graph.add_task(Task.new(tokens[0].to_i, :bfs))
        end
      end
    end
  end

  #nalezeni reseni
  def self.find_solutions
    for graph in @@graphs
      print "graph #{graph.id}\n"
      for task in graph.get_tasks
        start_node = graph.get_node(task.start)
        if task.pass.equal?(:dfs)
          dfs(start_node)
        else
          bfs(start_node)
        end

        print "\n"
        graph.refresh_nodes
      end
    end
  end

  def self.graphs
    @@graphs
  end

  private
  #prohledavani do sirky
  def self.dfs(node)
    opened = Array.new
    node.state = :opened
    opened.push(node)
    
    while !opened.empty?
      #odebirame posledne pridany prvek
      current = opened.pop
      if current.state.equal?(:closed)
        next
      end
      current.state = :closed
      print current.id

      #kvuli specifickym vystupum DFS alg. na serveru
      #spoj.pl musime revertovat nasledovniky uzlu
      successors = current.get_successors.reverse
      #pridame fresh sousedy do opened
      for successor in successors
        if !successor.state.equal?(:closed)
          successor.state = :opened
          opened.push(successor)
        end
      end

      if !opened.empty?
        print " "
      end
    end
  end

  #prohledavani do hloubky
  def self.bfs(node)
    opened = Array.new
    opened.push(node)

    while !opened.empty?
      #odebirame prvne pridany prvek
      current = opened.delete_at(0)
      current.state = :closed
      print current.id

      #pridame fresh sousedy do opened
      for successor in current.get_successors
        if successor.state.equal?(:fresh)
          successor.state = :opened
          opened.push(successor)
        end
      end

      if !opened.empty?
        print " "
      end
    end
  end

end

#g1 = Graph.new(1)
#p g1
#n1 = Node.new(1)
#p n1
#
#n2 = Node.new(2)
#g1.add_node(n1)
#n1.add_successor(n2)
#g1.add_node(n2)
#n3 = Node.new(3)
#n1.add_successor(n3)
#g1.add_node(n3)
#
#p n1
#
#t1 = Task.new(1, :bfs)
#t2 = Task.new(3, :dfs)
#
#g1.add_task(t1)
#g1.add_task(t2)
#p g1

Main.read_graphs
#Main.graphs.each { |graph| p graph }
Main.find_solutions