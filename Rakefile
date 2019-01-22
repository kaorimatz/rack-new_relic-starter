# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'rake/extensiontask'
Rake::ExtensionTask.new('rack_new_relic_starter')

task build: :compile
task default: %i[clobber compile spec rubocop]
