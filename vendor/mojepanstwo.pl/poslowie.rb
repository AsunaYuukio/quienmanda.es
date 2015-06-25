require_relative 'dataset.rb'

module Mojepanstwo_pl class Poslowie < Dataset
  def self.get
    get_all 'poslowie'
  end
end end
