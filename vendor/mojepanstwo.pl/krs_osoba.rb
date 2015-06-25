require_relative 'dataobject.rb'

module Mojepanstwo_pl class KrsOsoba < Dataobject
  def self.get id, layers=[]
    super 'krs/osoby', id, layers
  end

  def self.get_layer id, layer
    data = get id, [layer]
    data['object']['layers'][layer]
  end
end end
