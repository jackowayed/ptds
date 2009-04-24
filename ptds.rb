#!/usr/bin/env ruby

# Copyright (c) 2009 Daniel Jackoway
# Released under the MIT License. See COPYING for details

require 'tempfile'
class String
  def starts_with?(str)
    Regexp.new("^"+str) =~ self
  end
  # make sure you don't match variables with names like 'ifs'
  def starts_with_keyword?(str)
    self.stars_with?(str+':') || self.starts_with?(str+' ') || self == str
  def starts_with_one_of?(arr)
    arr.each do |str|
      return true if self.starts_with? str
    end
    false
  end
end
def good_to_normal(filename)
  indent_level = 0
  good_code = File.readlines(filename).collect do |line|
    line.strip!
    indent_level -= 1 if unindent_before? line
    new_line = indent comment_ruby_syntax(line), indent_level
    indent_level += 1 if indent_after? line
    new_line
  end
end
def indent_after?(line)
  starts_with_indenting_keyword? line || /do$/ =~ line
end
def starts_with_indenting_keyword?(line)
  line.starts_with_one_of? %w(def if else elif for class while try with except finally)
end
def unindent_before?(line)
  line.starts_with_one_of? %w(end else elif except finally)
end
#need to comment out the dos and ends
#comment mostly so that line #s stay the same
#(deleting ends would delete a line)
def comment_ruby_syntax(line)
  if line == "end"
    "#" + line
  elsif /do$/ =~ line
    line.insert /do$/ =~ line, "#"
  else
    line
  end
end
def indent(line, level)
  "  " * level + line
end
if ARGV[0] == "--compile" || ARGV[0] == "-c"
  puts good_to_normal(ARGV[-1])
else
  temp = Tempfile.new "goodpy-temp", File.dirname(__FILE__)
  code = good_to_normal(ARGV[-1])
  code.each do |line|
    temp << line << "\n"
  end
  temp.close
  %x[python #{ARGV[0..-2]*' '} #{temp.path}]
end

