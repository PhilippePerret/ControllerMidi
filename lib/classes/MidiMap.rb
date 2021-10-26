# encoding: UTF-8
# frozen_string_literal: true
=begin

  class MidiMap
  --------------

  Une MidiMap est une carte qui définit ce que font les notes.


=end
class MidiMap

# ------------------------------------------------------------------
#   CLASSE
# ------------------------------------------------------------------

class << self

  ##
  # Pour sélectionner une map
  #
  # @return {MidiMap} L'instance de la map choisie
  def choose
    if maps.count > 1
      name = Q.select("Map à utiliser :") do |q|
        q.choices [{name:"Première map", value:'first'}]
      end
    else
      name = maps.first[:value]
    end
    new(name)
  end

  ##
  # Retourne la liste des maps
  #
  def maps
    # TODO : la lire vraiment dans le dossier
    [
      {name: "Ma première map", value:"test"}
    ]
  end

  ##
  # Dossier contenant les maps
  #
  def folder
    @folder ||= File.join(APP_FOLDER,'Maps')
  end

end # /<< self


# ------------------------------------------------------------------
#   INSTANCE
# ------------------------------------------------------------------

attr_reader :name

def initialize name
  @name = name
end

##
# @return {MidiOperation} L'opération à exécuter sur la note
# {MidiKey} +midikey+
#
def operation(midikey)
  @operations ||= {}
  @operations[midikey.note] ||= MidiOperation.new(data[midikey.note])
end

##
# @return TRUE s'il existe une opération pour la touche {MidiKey}
# +midikey+
#
def has_operation?(midikey)
  data.key?(midikey.note) 
end

def data
  @data ||= begin
    dd = YAML.load_file(path)
    #
    # Quelques petites transformations
    #
    dd.each do |note, dnote|
      dd[note] = dnote.merge!(note: note)
    end

    dd
  end
end

def path
  @path ||= File.join(self.class.folder, "#{name}.yaml")
end
end
