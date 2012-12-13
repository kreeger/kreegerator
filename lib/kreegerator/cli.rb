require 'logger'
require 'thor'
require 'kreegerator'

class Kreegerator::CLI < Thor

  map '-i' => :ios

  desc 'ios TEMPLATE CLASS_NAME', 'fire off an iOS generator'
  method_option %w(destination -d), desc: 'The destination where the file will end up.'
  def ios(method_name, filename)
    if Kreegerator::IOS.respond_to?(method_name.to_sym)
      Kreegerator::IOS.send(method_name.to_sym, path_helper(options[:destination]), filename)
    else
      puts 'That generator does not exist.'
    end
  end

  private

  def path_helper(path)
    if path.nil?
      path = Dir.pwd
    elsif !File.directory?(path)
      path = File.basename(path)
    end
    path
  end
end
