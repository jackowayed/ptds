#!/usr/bin/env ruby
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
  %w(def if else for class try while).each do |keyword|
    return true if Regexp.new("^"+keyword) =~ line
  end
  false
end
def unindent_before?(line)
  "end" == line
end
#need to comment out the dos and ends
#comment mostly so that line #s stay the same
#(deleting ends would delete a line)
def comment_ruby_syntax(line)
  if unindent_before? line
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
puts good_to_normal('test.gpy')
