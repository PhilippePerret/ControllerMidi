#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true
require_relative 'lib/_required'


midicontroller = MidiController.init
while operation = MidiController.choose_operation
  midicontroller.send(operation)
end
