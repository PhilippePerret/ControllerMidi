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
      name = Q.select("Map de touches à utiliser :".bleu) do |q|
        q.choices maps
        q.per_page maps.count
      end || return
    else
      name = maps.first[:value]
    end

    return new(name)
  end

  ##
  # Pour afficher une map
  #
  def display_map(map = nil)
    map ||= choose || return
    map.display
  end

  ##
  # Pour ouvrir une map pour pouvoir la définir
  #
  def define_map(map = nil)
    map ||= choose || return
    map.open
  end

  ##
  # Retourne la liste des maps
  #
  def maps
    @maps ||= begin
      Dir["#{folder}/*.yaml"].collect do |path|
        dmap = YAML.load_file(path)
        affixe = File.basename(path, File.extname(path))
        {name: (dmap['titre']||dmap[:titre]||affixe), value:affixe}
      end << CHOIX_RENONCER
    end
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
# Affichage de la map
# --------------------
# L'affichage se fait par un fichier HTML où se dessine le 
# clavier, avec les touches définies
#
def display
  puts "Je dois apprendre à afficher la map #{name}".jaune
end

##
# Ouverture de la map
# -------------------
# Va permettre de la définir
#
def open
  `open "#{path}"`
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
      note != 'titre' || next
      dd[note] = dnote.merge!(note: note)
    end

    dd
  end
end

def path
  @path ||= File.join(self.class.folder, "#{name}.yaml")
end
end
