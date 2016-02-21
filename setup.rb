#!/usr/bin/ruby

require 'fileutils'
require 'pry'

home = ENV["HOME"]
dotfiles_dir = "#{home}/src/dotfiles"

def copyFile(new_file, old_file)
  puts "Diffing: #{new_file} and #{old_file}"
  puts `diff #{new_file} #{old_file}`
  print "Approve? (y,n) "
  return if gets.chomp == "n"

  FileUtils.cp(new_file, old_file)
end

copyFile("#{dotfiles_dir}/zshrc.zsh", "#{home}/.zshrc")
copyFile("#{dotfiles_dir}/gitconfig", "#{home}/.gitconfig")
copyFile("#{dotfiles_dir}/vimrc", "#{home}/.vimrc")
