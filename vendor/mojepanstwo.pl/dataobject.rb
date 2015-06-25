require_relative 'mojepanstwo_pl.rb'

module Mojepanstwo_pl class Dataobject

  def self.get dataobject, id, layers
    dataobject = Mojepanstwo_pl.get "#{dataobject}/#{id}", {layers: layers}
    if dataobject["object"]
      dataobject
    end
  end

end end
