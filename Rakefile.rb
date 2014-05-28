require "erb"
require "pathname"
require "pry"

GRUNTFILE = "Gruntfile"
NAME_TEMPLATE_IDENTIFIER = "NAME"

class Package
  attr_reader :name, :description, :build

  def initialize(name, description, build)
    @name, @description, @build = name, description, build
  end
end

class GabeFile < Pathname
  GRUNTFILE_REGEXP = Regexp.new(GRUNTFILE, 'i').freeze
  NAME_TEMPLATE_REGEXP = Regexp.new(NAME_TEMPLATE_IDENTIFIER).freeze

  attr_accessor :package

  def self.glob(exp, package)
    glob = super(exp)
    glob.map do |pathname|
      pathname.tap { |pn| pn.package = package }
    end
  end

  def gruntfile?
    !!GRUNTFILE_REGEXP.match(to_s)
  end

  def build_file_name
    if templated_name?
      template_name = to_s.gsub(NAME_TEMPLATE_IDENTIFIER, package.name)
    else
      template_name = to_s
    end
    "#{package.build}/#{template_name}"
  end

  private

  def templated_name?
    !!NAME_TEMPLATE_REGEXP.match(to_s)
  end
end

def option(text)
  print(text)
  STDIN.gets.chomp
end

task :default do
  puts %q{
                                  __
   ____  ____ _      ____ _____ _/ /_  ___
  / __ \/ __ `/_____/ __ `/ __ `/ __ \/ _ \
 / / / / /_/ /_____/ /_/ / /_/ / /_/ /  __/
/_/ /_/\__, /      \__, /\__,_/_.___/\___/
      /____/      /____/

An AngularJS plugin generator for Gabe (^_^ )

}

  package_name = option("Name that package: ")
  package_description = option("Description that package: ")
  build_path = option("What do you want to put that package? ")

  library_path = "#{build_path.length > 0 ? build_path : '.'}/angular-#{package_name}"
  @package = Package.new(package_name, package_description, library_path)

  FileUtils.mkdir(@package.build)

  glob = GabeFile.glob('{{,*/}*,{.gitignore,.jshintrc}}', @package)
  files = glob.select(&:file?)
  directories = glob.select(&:directory?)

  directories.each { |d| FileUtils.mkdir_p("#{@package.build}/#{d}") }

  files.each do |f|
    fo = f.open
    result = if !f.gruntfile?
               ERB.new(fo.read).result
             else
               fo.read
             end
    fo.close

    output_file = File.new(f.build_file_name, "w")
    output_file.write(result)
    output_file.close
  end
end
