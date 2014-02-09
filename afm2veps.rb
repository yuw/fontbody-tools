#! /usr/bin/env ruby
# vertual body realizator
# version 0.1
# ruby afm2veps.rb AFM-file output-dir
#

def zero_or_not(elem)
  if elem == 0
    0
  else
    elem
  end
end

Dir.mkdir(ARGV[1]) unless File.exist?(ARGV[1]) unless ARGV[1].nil?

afm_which = `kpsewhich #{ARGV[0]}.afm`.sub(/\n/,"")
system("cp #{afm_which} ./")
afm = File.read(afm_which)
charmetrics = afm.slice(/StartCharMetrics.*EndCharMetrics/m)
charmetrics = charmetrics.split(/\n/)
charmetrics.each do |elem|
  elem = elem.split(/;/)
  next if /\AStartCharMetrics/ =~ elem[0]
  next if /\AEndCharMetrics/ =~ elem[0]
  p elem = [elem[0].sub(/\AC /,"").sub(/ \z/,""),elem[1].sub(/\A WX /,"").sub(/ \z/,""),elem[2].sub(/\A N /,"").sub(/ \z/,""),elem[3].sub(/\A B /,"").sub(/ \z/,"")]
  maxwidth = zero_or_not(elem[1].to_i)
  bound_height = zero_or_not(elem[3].split(/ /)[3].to_i)
  bound_left = zero_or_not(elem[3].split(/ /)[0].to_i)
  bound_right = zero_or_not(elem[3].split(/ /)[2].to_i)
  bound_depth = zero_or_not(elem[3].split(/ /)[1].to_i)
  if bound_depth > 0
    max_bound_depth = 0
  else
    max_bound_depth = bound_depth
  end
  extra_width = 100
  extra_width = -bound_left if bound_left < -extra_width
  extra_bound_left = -extra_width
  extra_bound_left = bound_left - extra_width if bound_left - extra_width < extra_bound_left
  extra_bound_right = bound_right + 2 * extra_width
  output_dir = ARGV[1].to_s
  output_dir = output_dir + "/" unless /\/$/ =~ output_dir
  eps_file = "#{output_dir}c#{elem[0].rjust(3,"0")}.eps"
  File.open(eps_file, "w") do |file|
  file.puts <<HEREDOC
%!PS-Adobe-3.0 EPSF-3.0
%%Creator: pl2eps.rb
%%For: () ()
%%Title: (box of character "#{elem[2]}")
%%CreationDate:
%%width = #{maxwidth}bp, height = #{bound_height}bp, depth = #{-bound_depth}bp
%%BoundingBox: #{-extra_width} #{max_bound_depth} #{bound_right + extra_width} #{bound_height}
%%HiResBoundingBox: #{-extra_width} #{max_bound_depth} #{bound_right + extra_width} #{bound_height}
20 setlinewidth
#{bound_left + 10} #{bound_depth + 10} moveto
0 #{bound_height - bound_depth - 20} rlineto #{bound_right - bound_left - 20} 0 rlineto
0 #{-bound_height + bound_depth + 20} rlineto closepath stroke
#{extra_bound_left} 10 moveto
HEREDOC
  end
end
