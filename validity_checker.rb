# frozen_string_literal: true

require 'date'
require 'colorize'
require './readers'
require './data_calculator'

class ValidityChecker < DataCalculator
  def month_assigner(month)
    return puts 'Wrong Month Entered!' unless (1..12).include?(month.to_i)
    month = Date.parse("2000-#{month}-1", '%Y-%m-%d').strftime('%B')
    month[0, 3]
  end

  def second_arg_checker_month(arguments, bar_checker)
    case arguments[1].include?('/')
    when true
      month_get(arguments, bar_checker)
    else
      argument_error_printer
    end
  end

  def argument_error_printer
    puts 'Wrong Arguments Entered!'
    exit
  end

  def second_arg_checker_year(arguments)
    argument_error_printer if arguments[1].length != 4
    case arguments[1].to_i
    when 1996..2016
      by_year(arguments[2], arguments[1])
    else
      argument_error_printer
    end
  end

  def first_arg_checker(arguments)
    case arguments[0]
    when '-e'
      second_arg_checker_year(arguments)
    when '-a'
      second_arg_checker_month(arguments, false)
    when '-c'
      second_arg_checker_month(arguments, true)
    else
      argument_error_printer
    end
  end

  def start(arguments)
    case arguments.length
    when 3
      first_arg_checker(arguments)
    else
      argument_error_printer
    end
  end
end
