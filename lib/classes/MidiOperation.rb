# encoding: UTF-8
# frozen_string_literal: true
=begin

  Classe MidiOperation
  --------------------
  Une opération quelconque à jouer.
  Elle reçoit à l'instanciation les données définies dans une map
  pour la note donnée

=end
class MidiOperation

##
# = main =
#
# Exécution de l'opération (en fonction de son type)
def exec
  puts "-> appel de exec_#{type}"
  send("exec_#{type}".to_sym)
end

# ================================
# Exécution par type d'opération

def exec_clipboard
  `echo "#{content.gsub(/\"/,'\\"')}" | pbcopy`
  puts "J'ai mis “#{content}” dans le presse-papier."
end


# /Fin exécution par type d'opération
# ====================================

attr_reader :data
def initialize(data)
  @data = data
end

def titre
  @titre ||= data['titre']||data[:titre]
end
def type
  @type ||= data['type']||data[:type]
end
def content
  @content ||= data['content']||data[:content]
end


end #/MidiOperation