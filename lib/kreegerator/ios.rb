class Kreegerator::IOS

  def self.view_controller(path, name)
    puts "Generating file for #{name} in #{File.expand_path path}."
  end

  class << self
    alias_method :vc, :view_controller
    alias_method :viewcontroller, :view_controller
    alias_method :controller, :view_controller
  end

end
