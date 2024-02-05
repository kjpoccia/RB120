=begin
[nil, nil, nil]
[1, nil, nil]
[1, 2, nil] pop off the first, shift everything over
[2, nil, nil]
[2, 3, nil]
[2, 3, 4] pop off 2, shift everything over
[3, 4, nil]
[3, 4, 5]
[4, 5, 6]
[5, 6, 7]
[6, 7, nil]
[7, nil, nil]
[nil, nil nil]

Algorithm:
- Initialize an array of size given
- When an element is added, add it to the first empty spot in the array
- if there are no empty spots in the array, remove the first element
  and add the new element to the end
- To remove and return the oldest element, pop it

=end

class CircularQueue
  attr_accessor :queue

  def initialize(size)
    @queue = Array.new(size)
  end

  def enqueue(obj)
    if queue.find_index(nil)
      self.queue[queue.find_index(nil)] = obj
    else
      self.dequeue
      queue[-1] = obj
    end
  end

  def dequeue
    queue << nil
    queue.shift
  end
end


queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil