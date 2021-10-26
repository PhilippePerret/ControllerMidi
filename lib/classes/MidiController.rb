# encoding: UTF-8
# frozen_string_literal: true
=begin

  Classe MidiController
  ---------------------
  Moteur de l'application. C'est lui qui gère les entrées (MIDI)
  et les sorties (Opérations).

  Dès qu'on lance l'application, une instance de contrôleur est 
  créée, qui va tout gérer.
  
=end

class MidiController

# ------------------------------------------------------------------
#   CLASSE
# ------------------------------------------------------------------
class << self

  ##
  # Initialisation de l'application
  #
  # @return {MidiController} Le contrôleur créé
  #
  def init
    midictr = new(get_input, MidiMap.choose)
    return midictr  
  end

  ##
  # Pour choisir l'entrée
  #
  # Pour le moment, toujours la première
  def get_input
    UniMIDI::Input.use(:first)
  end

end #/<< self


# ------------------------------------------------------------------
#   INSTANCES
# ------------------------------------------------------------------

attr_reader :input
attr_reader :midimap

##
# Initialisation
#
# @param {UniMIDI::Input} input Entrée MIDI utilisée
# @param {MidiMap} midimap    Carte des opérations par touche
#
def initialize(input, midimap)
  @midimap = midimap
  @input   = input
end

##
# Lancement de l'écoute
#
def start
  while true do
    #
    # On attend la prochaine touche
    #
    m = input.gets
    # m est un truc de la forme :
    # [{:data=>[144, 62, 54], :timestamp=>1635174645.9315069}, {:data=>[128, 62, 0], :timestamp=>1635174646.0889962}]
    if m.count > 0
      study_keys(m) || break
    end
  end
end #/start

def study_keys(m)
  #
  # On passe ici quand une ou plusieurs touches ont été pressées
  #
  touches = []
  m.collect do |dkey| 
    mk = MidiKey.new(dkey)
    if @last_time && mk.on? && mk.key == @last_key && (mk.time - @last_time) < 1
      # TODO : En fait, demander ce qu'il faut faire
      return false # pour s'arrêter
    else
      @last_time  = mk.time
      @last_key   = mk.key
    end
    mk.on? && touches << mk
  end
  #
  # On exécute chaque touche
  #
  touches.each do |midikey| 
    traite(midikey)
  end

  return true # pour continuer  
end
#/ study_keys

##
# Traitement de la note midi
#
def traite(midinote)
  puts "-> #{midinote.ref}"
  if midimap.has_operation?(midinote)
    midimap.operation(midinote).exec
  else
    puts "Pas d'opération pour cette touche"
  end
end


end #/MidiControler
