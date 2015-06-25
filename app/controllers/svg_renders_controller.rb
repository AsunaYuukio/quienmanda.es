class SvgRendersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  DIR = "#{Rails.root}/public/uploads/relation/"
  SVG_DIR = "#{DIR}/svg"
  JPG_DIR = "#{DIR}/jpg"

  def create
    require 'fileutils'
    unless File.exists? SVG_DIR
      FileUtils.mkdir_p SVG_DIR
    end
    unless File.exists? JPG_DIR
      FileUtils.mkdir_p JPG_DIR
    end
    require 'securerandom'
    uuid = SecureRandom.uuid
    svg_path = "#{SVG_DIR}/#{uuid}.svg"
    File.open(svg_path, 'w') do |file|
      file.write svg_param
    end
    errors = svg_to_jpg uuid

    
    if errors == ""
      render json: {url: "#{root_url}/uploads/relation/jpg/#{uuid}.jpg"}
    else
      render json: {errors: errors}
    end
  end

  private

  def svg_param
    params.require(:svg)
  end

  def svg_to_jpg uuid
    `convert #{SVG_DIR}/#{uuid}.svg #{JPG_DIR}/#{uuid}.jpg`
  end
end
