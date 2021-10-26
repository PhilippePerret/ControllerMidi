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
    midictrl = new(get_input)
    return midictrl
  end


  ##
  # Pour choisir l'opération à exécuter
  #
  def choose_operation
    clear
    Q.select("Opération à exécuter :") do |q|
      q.choices OPERATIONS_MIDICONTROLLER
      q.per_page OPERATIONS_MIDICONTROLLER.count
    end
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

#
# La carte des touches à utiliser
#
# :midimap

##
# Initialisation
#
# @param {UniMIDI::Input} input Entrée MIDI utilisée
# @param {MidiMap} midimap    Carte des opérations par touche
#
def initialize(input, midimap = nil)
  @midimap = midimap
  @input   = input
end

# =====================================
# OPÉRATIONS GÉNÉRALES

##
# Lancement de l'écoute du clavier
#
def start
  midimap # pour en choisir une le cas échéant
  clear
  puts "Pressez une touche du clavier MIDI\nDO2 (le plus à gauche) => aperçu des touches\n(2 DO séparés de 2 octave pour finir)".bleu
  puts ("-"*60).bleu
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

##
# Affichage d'une map
def display_map
  MidiMap.display_map
end

##
# Définition d'une map choisie
#
def define_map
  MidiMap.define_map
end

# /FIN DES OPÉRATIONS GÉNÉRALES
# =====================================

# ----------------------
# Sous-opérations


##
# Étude des touches pressées
# --------------------------
# @param {Array} m  contient la liste de toutes les touches pressées
#                   en même temps
def study_keys(m)
  # puts "Étude de : #{m.inspect}"
  #
  # On passe ici quand une ou plusieurs touches ont été pressées
  #
  touches = []
  m.collect do |dkey| 
    mk = MidiKey.new(dkey)
    if mk.on?
      if mk.note_name == 'C'
        if @last_do && (@last_do.octave - mk.octave).abs == 2
          return false
        end
        @last_do = mk
      end
    else
      if mk.note_name == 'C' && @last_do && mk.octave == @last_do.octave
        @last_do = nil
      end
      touches << mk # on ne tient compte que les NOTE-OFF
    end
  end

  #
  # On exécute chaque touche (s'il y en a)
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
  puts "-> #{midinote.ref}".vert
  if midinote.note == 'C2'
    midimap.display
  elsif midimap.has_operation?(midinote)
    midimap.operation(midinote).exec
  else
    puts "Pas d'opération pour la touche #{midinote.note}".bleu
  end
end


##
# Pour choisir la map de touches à utiliser
#
def midimap
  @midimap ||= MidiMap.choose
end
# setter
def midimap= map
  @midimap = map
end

end #/MidiControler
