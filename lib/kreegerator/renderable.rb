require 'tilt'
require 'erb'

# This module uses the amazing Tilt library to give the ability to render
# a template in the `lib/filemover/templates` directory to any including
# class.
module Kreegerator
  module Renderable

    # Accepts path to a template relative to `lib/filemover/templates` along
    # with a hash and renders a template using the amazing and magical Tilt.
    #
    # @param [String] template the relative path to the template, from
    #                 `lib/filemover/templates`.
    # @param [Hash] data the hash of values to render. The keys will be sent
    #               to the template as instance variables `@like_this`.
    def render(template, data)

      # META! Assign instance variables to self using the hash passed in.
      data.each { |key, value| instance_variable_set "@#{key}", value }

      # Get the absolute template location relative to our template basepath.
      template_location = File.join(template_path, template)

      # Let Tilt do the rest. Also pass in `self` as that's the reference to
      # the object that holds our new, metaprogrammed `@instance_variables`.
      Tilt.new(template_location).render(self)
    end

    protected

    # A helper that provides the absolute path to `Filemover`'s master template
    # directory at `lib/filemover/templates`.
    #
    # @return [String] the absolute path of the `templates` directory.
    def template_path
      File.expand_path('../../../templates', __FILE__)
    end
  end
end
