#!/usr/bin/ruby

require 'fileutils'
require 'pry'

home = ENV["HOME"]

def copyFile(new_file, old_file)
  puts "Diffing: #{new_file} and #{old_file}"
  puts `diff #{new_file} #{old_file}`
  print "Approve? (y,n) "
  return if gets.chomp == "n"

  FileUtils.cp(new_file, old_file)
end

copyFile('zshrc.zsh', "#{home}/.zshrc")
copyFile('gitconfig', "#{home}/.gitconfig")

binding.pry
