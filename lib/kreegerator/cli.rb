require 'logger'
require 'thor'
require 'kreegerator'

class Kreegerator::CLI < Thor

  map '-i' => :ios
  map '-r' => :retina

  desc 'ios TEMPLATE CLASS_NAME', 'fire off an iOS generator'
  method_option :destination, desc: 'The destination where the file will end up.'
  def ios(method_name, filename=nil)
    if Kreegerator::IOS.respond_to?(method_name.to_sym)
      if method_name == 'list'
        Kreegerator::IOS.send(method_name.to_sym)
      else
        Kreegerator::IOS.send(method_name.to_sym, path_helper(options[:destination]), filename)
      end
    else
      puts "The generator you asked for ('#{method_name}') does not exist."
    end
  end

  desc 'retina ACTION GLOB', 'handles image adjustments for retina displays'
  method_option :pngnq, desc: 'Runs the files through pngnq as well.', type: :integer
  def retina(method_name, glob)
    if Kreegerator::Retina.respond_to?(method_name.to_sym)
      if method_name == 'list'
        Kreegerator::Retina.send(method_name.to_sym)
      else
        Kreegerator::Retina.send(method_name.to_sym, glob, options)
      end
    else
      puts "The action you asked for ('#{method_name}') does not exist."
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
