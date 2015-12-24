require 'rubygems' rescue nil
require 'wirble'
require 'ap'
require 'interactive_editor'
require 'timecop'

IRB.conf[:AUTO_INDENT] = true

if defined?(Rails) && !Rails.env.nil?
  if Rails.logger
    Rails.logger =Logger.new(STDOUT)
    ActiveRecord::Base.logger = Rails.logger
  end
  if Rails.env == 'test'
    require 'spec_helper'
  end
	# Load up my custom gemset from the gem file
	# Bundler.require :default, Rails.env, :sean_tools
else
  # nothing to do
end

# annotate column names of an AR model
def show(obj)
  y(obj.send("column_names"))
end

def columns(model_class, filter_by=nil)
  columns = model_class.columns_hash.keys
  columns.select! {|c| c =~ filter_by} if filter_by
  ap columns.sort
  nil
end

puts "> all systems are go <"
