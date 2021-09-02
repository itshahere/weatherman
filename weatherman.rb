# frozen_string_literal: true

require 'date'
require 'colorize'
require './readers'
require './data_calculator'
require './validity_checker'

ValidityChecker.new.start(ARGV)
