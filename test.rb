require 'date'
if $DEBUG
	puts "debuggin"
end
t = STDIN.read
puts "#{$0} (#{DateTime.now.to_s}): #{t} (#{t && t.length})"
