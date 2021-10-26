# encoding: UTF-8
# frozen_string_literal: true
=begin

  classe MidiKey
  --------------
  Classe des touches pressées
  Dès qu'une touche est pressée sur le clavier maitre, une instance
  MidiKey est produite. Qui peut être appelée pour traiter 
  l'opération si elle est définie

=end
class MidiKey

  GAMME_CHROMATIQUE = ['C','C#','D','D#','E','F','F#','G','G#','A','A#','B']

attr_reader :data

#
# La touche pressée, par exemple 60 (key) pour un DO3 (note)
#
attr_reader :key
attr_reader :note

#
# Le premier chiffre où 144 correspond à NOTE ON et 128 à NOTE OFF
#
attr_reader :onoff

#
# Temps, en millisecondes
#
attr_reader :time

#
# Vélocité de la nonte
#
# Normalement, pas utilisé ici, mais on pourrait imaginer que 
# certaines commandes soient sensible à la vélocité (quand on doit
# utiliser un nombre par exemple)
attr_reader :velocite



def initialize(data)
  dispatch(data)
end

def ref
  @ref ||= "NOTE: #{note.ljust(4)} KEY:#{key.to_s.ljust(3)} ON:#{on? ? 'vrai' : 'faux'}" 
end

def dispatch(data)
  @data = data
  @onoff, @key, @velocite = data[:data]
  @time = data[:timestamp]
end

##
# Affichage de la note, si demandé par les configurations
# de l'application/utilisateur
#
def display
  puts ref
end

#
# @return TRUE si c'est une NOTE ON
def on?
  @onoff == 144
end


def note
  @note ||= get_note
end

##
# Retourne la note sous forme de <nom><octave>. Par exemple 'DO3'
#
# Les octaves
# 12(-1), 24(0), 36(1), 48(2), 60(3), 72(4), 84(5), 96(6)
def get_note
  octave = key / 12 - 2
  n = GAMME_CHROMATIQUE[key - (octave + 2) * 12]
  "#{n}#{octave}"
end

end #/MidiKey
