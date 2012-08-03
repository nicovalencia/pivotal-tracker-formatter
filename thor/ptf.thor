require 'csv'
require 'erb'
require 'thor'
require './lib/parser'

class PTF < Thor

  desc "format SOURCE_FILE OUTPUT_FILE", "format csv"
  method_option :template, :aliases => "-t", :desc => "Choose template to write to: [sow]"
  method_option :label, :aliases => "-l", :desc => "Filter by label"
  method_option :categories, :aliases => "-c", :desc => "Group by categories (comma separated string)"

  def format(source_file, output_file)
    doc = Parser.new(source_file, output_file, options)
    doc.write(options[:template])
  end

end

