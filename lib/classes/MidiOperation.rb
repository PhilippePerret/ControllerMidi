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
  # puts "-> appel de exec_#{type}"
  send("exec_#{type}".to_sym)
end

# ================================
# Exécution par type d'opération

def exec_clipboard
  puts "\n\n"
  `echo "#{content.gsub(/\"/,'\\"')}" | pbcopy`
  puts "J'ai mis “#{content}” dans le presse-papier.".vert
end

def exec_notice
  puts "\n\n"
  puts content.bleu
end

def exec_url
  puts "\n\nJe rejoins l'adresse #{content}…".bleu
  `open -a Safari #{content}`
end

##
# Pour ouvrir un fichier
#
def exec_file
  puts "\n\nJ'ouvre #{content}…".bleu
  cmd = ['open']
  if app
    cmd << "-a \"#{app}\""
  end
  cmd << "\"#{content}\""
  cmd = cmd.join(' ')
  `#{cmd}`
end

##
# Pour ouvrir un dossier
#
def exec_folder
  puts "\n\nJ'ouvre le dossier #{content}…".bleu
  `open -a Finder "#{content}"`
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
def app
  @app ||= data['app']||data[:app]
end


end #/MidiOperation
