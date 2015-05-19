require 'thread'

count1 = count2 = 0

a = "1111"

Thread.new(a){|d|
  d = a
  puts d
}