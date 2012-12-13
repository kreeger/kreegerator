require 'kreegerator/renderable'

class Kreegerator::IOS

  class << self
    include Kreegerator::Renderable

    def list
      puts methods(false).select { |m| m != :list }.join("\n")
    end

    def view_controller(path, name)
      puts "Generating file for #{name} in #{File.expand_path path}."
      render_headers_and_implementations 'view_controller', name, {}, path
    end
    alias_method :vc, :view_controller
    alias_method :viewcontroller, :view_controller
    alias_method :controller, :view_controller

    private

    def render_headers_and_implementations(template, class_name, data, destination_path)
      data.merge!({ class_name: class_name })
      renders = Hash[%w(h m).map { |t| [t.to_sym, render("ios/#{template}.#{t}.erb", data)] }]
      renders.each do |type, contents|
        filename = File.join File.expand_path(destination_path), "#{class_name}.#{type}"
        File.open(filename, 'w') { |f| f.write contents }
      end
    end
  end
end
