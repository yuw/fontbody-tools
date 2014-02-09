#! /usr/bin/env ruby
# vertual body realizator
# version 0.1
#

output_dir = ARGV[0].to_s
output_dir = output_dir + "/" unless /\/$/ =~ output_dir

afm = File.read(ARGV[2])
fontname = afm.slice(/^FontName (.*?)$/,1)
fullname = afm.slice(/^FullName (.*?)$/,1)
familyname= afm.slice(/^FamilyName (.*?)$/,1)
weight = afm.slice(/^Weight (.*?)$/,1)
charmetrics = afm.slice(/StartCharMetrics.*EndCharMetrics/m)
charmetrics = charmetrics.split(/\n/)
$char_order_name = Hash.new
charmetrics.each do |elem|
  elem = elem.split(/;/)
  next if /\AStartCharMetrics/ =~ elem[0]
  next if /\AEndCharMetrics/ =~ elem[0]
  $char_order_name.store(elem[0].sub(/\AC /,"").sub(/ \z/,""),
                         elem[2].sub(/\A N /,"").sub(/ \z/,""))
end

eps_dir = Dir.glob("#{output_dir}*.eps")
eps_dir.each do |eps|
  char_count = File.basename(eps,".eps").sub(/\Ac/,"")
  char_count = char_count.sub(/\A0/,"") if /\A0/ =~ char_count
  char_count = char_count.sub(/\A0/,"") if /\A0/ =~ char_count
  eps_file = File.read(eps)
  width = eps_file.slice(/^%%width = (.*?)bp/,1)
  unless File.exist?(ARGV[1])
    File.open("create.ff","w") do |file|
      file.puts <<HEREDOC
New()
Save("#{ARGV[1]}")
Close()

Quit()
HEREDOC
    end
    system("fontforge -script ./create.ff")
    File.unlink("create.ff") if File.exist?("create.ff")
  end
  File.open("#{char_count.to_s}.ff", "w") do |file|
    p eps
    file.puts <<HEREDOC
Open("#{ARGV[1]}")

Select(#{char_count.to_i})
SetGlyphChanged(0)
Import("#{eps}",0,2)
SetWidth(#{width.to_i})

Save("#{ARGV[1]}")
Close()

Quit()
HEREDOC
  end
  system("fontforge -script ./#{char_count.to_s}.ff")
  File.unlink("./#{char_count.to_s}.ff")
end

$char_order_name.each do |k,v|
  File.open("create.ff","w") do |file|
    p v
    file.puts <<HEREDOC
Open("#{ARGV[1]}")
Select(#{k.to_i})
SetGlyphName("#{v.to_s}")
Save("#{ARGV[1]}")
Close()

Quit()
HEREDOC
  end
  system("fontforge -script ./create.ff")
  File.unlink("create.ff")
end

File.open("create.ff","w") do |file|
  file.puts <<HEREDOC
pfb_name = "#{ARGV[1]}"
Open(pfb_name)
SelectAll()
MergeKern("#{ARGV[2]}")
SetFontNames("Box-#{fontname}","#{familyname}","Box-#{fullname}","#{weight}")
Save(pfb_name)
Generate(pfb_name:r + ".pfb","",0x10000)
Close()

Quit()
HEREDOC
end
system("fontforge -script ./create.ff")
File.unlink("create.ff")
