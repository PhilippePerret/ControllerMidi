# encoding: UTF-8


CHOIX_RENONCER = {name:'Renoncer/finir', value: nil}

#
# Les opérations générales du midicontroller
#
OPERATIONS_MIDICONTROLLER = [
  {name:"Surveiller le clavier",  value: :start},
  {name:"Visualiser une map",     value: :display_map},
  {name:"Définir une map",        value: :define_map}
] << CHOIX_RENONCER


