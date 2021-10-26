# encoding: UTF-8
# frozen_string_literal: true

require "unimidi"
require 'yaml'
require 'tty-prompt'
Q = TTY::Prompt.new(symbols: {radio_on:"☒", radio_off:"☐"}) # cross : essai pour utiliser disabled dans les listes pour des sous-titres

#
# Constants path
#
LIB_FOLDER = __dir__
APP_FOLDER = File.dirname(LIB_FOLDER)

require_relative 'constants'

#
# Charger toutes les classes de l'application
#
Dir["#{__dir__}/required/*.rb"].each do |m| require m end
Dir["#{__dir__}/classes/*.rb"].each do |m| require m end

