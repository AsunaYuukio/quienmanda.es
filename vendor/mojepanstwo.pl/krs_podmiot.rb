require_relative 'dataobject.rb'

module Mojepanstwo_pl class KrsPodmiot < Dataobject
  def self.get id, *layers
    super 'krs/podmioty', id, layers
  end
end end