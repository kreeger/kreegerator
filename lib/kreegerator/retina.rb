require 'FileUtils'
require 'mini_magick'

class Kreegerator::Retina

  class << self

    def list
      puts methods(false).select { |m| m != :list }.join("\n")
    end

    def downscale(glob, opts)
      Dir[glob].select { |f| f =~ /\.png\Z/i }.each do |file|
        puts "Downscaling #{file}."
        scale_image file, 0.5, true
        crunch_image(file, opts[:pngnq]) if opts[:pngnq]
      end
    end

    private

    def scale_image(file, multiplier, is_retina)
      file = adjust_name_if_needed file, is_retina
      image = MiniMagick::Image.open file
      new_dim = [(image[:width] * multiplier).to_i, (image[:height] * multiplier).to_i].join('x')
      new_name = file.gsub '@2x.png', '.png'
      image.resize new_dim
      image.write new_name
    end

    def crunch_image(file, colors)
      puts "Crunching image #{file}."
      cmd = "pngnq #{file} -f -s 1"
      cmd << " -n #{colors}" unless colors.nil?
      system cmd
    end

    def adjust_name_if_needed(file, is_retina)
      return file if is_retina && file =~ /@2x\./
      new_file = file.gsub '.png', '@2x.png'
      FileUtils.mv(file, new_file)
      new_file
    end
  end
end
