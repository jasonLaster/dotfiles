#!/usr/bin/env ruby

commands = File.readlines("/home/jlaster/.gitconfig")
commands = commands
    .reject {|command| command[/\[/]} # remove the [core] and other groups
    .map { |command| command.strip.split("=")[0] } # grab the aliases
    .reject {|command| command.nil? } # remove empty lines
    .map(&:strip)

    # ignores name and other group properties
    #

commands.each do |command|
    puts "g#{command}=\\\"git #{command}\\\""
end


