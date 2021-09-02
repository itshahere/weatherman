# frozen_string_literal: true

require 'date'
require 'colorize'
require './readers'

class DataCalculator < Readers
  def data_splitter(file)
    result = []
    file.each_line do |line|
      result << line.split(',') if (line[4] != 'M') && (line[0] == '2' || line[0] == '1')
    end
    result
  end

  def bar_printer(day, character, hightemp, lowtemp)
    temp_var1 = hightemp
    temp_var2 = lowtemp
    day = "0#{day}" if day < 10
    hightemp = "0#{hightemp}" if hightemp < 10
    lowtemp = "0#{lowtemp}" if lowtemp < 10
    day = day.to_s
    hightemp = hightemp.to_s
    lowtemp = lowtemp.to_s
    puts "#{day} #{(character * temp_var1).red} #{hightemp}C"
    puts "#{day} #{(character * temp_var2).blue} #{lowtemp}C"
  end

  def by_year_calc_date_checker(result, counter)
    (return unless result[counter][0].start_with?('2', '1'))
    result[counter][0] = Date.parse(result[counter][0], '%Y-%m-%d').strftime('on %B %d')
  end

  def by_year_values_updater(result, counter, init_vals, index)
    init_vals[index[1]] = result[counter][index[0]].to_i
    init_vals[index[2]] = result[counter][0]
  end

  def by_year_calc_condition_checker(result, counter, init_vals, index, check)
    if check == true
      (return unless result[counter][index[0]].to_i > init_vals[index[1]])
    else
      (return unless result[counter][index[0]].to_i < init_vals[index[1]])
    end
    by_year_values_updater(result, counter, init_vals, index)
  end

  def by_year_calc_result(init_vals)
    puts "Highest: #{init_vals[0]}C #{init_vals[1]}"
    puts "Lowest: #{init_vals[2]}C #{init_vals[3]}"
    puts "Humid: #{init_vals[4]}% #{init_vals[5]}"
  end

  def by_year_calc(init_vals, result)
    counter = 0
    indexes = [[1, 0, 1], [3, 2, 3], [7, 4, 5]]
    result.each do
      by_year_calc_date_checker(result, counter)
      by_year_calc_condition_checker(result, counter, init_vals, indexes[0], true)
      by_year_calc_condition_checker(result, counter, init_vals, indexes[1], false)
      by_year_calc_condition_checker(result, counter, init_vals, indexes[2], true)
      counter += 1
    end
    by_year_calc_result(init_vals)
  end

  def by_year(path, year)
    result = []
    init_vals = []
    month = ''
    result = file_reader(result, dir_reader(path, year, month))
    init_vals += [-100_00, '', 100_00, '', -100_00, '']
    by_year_calc(init_vals, result)
  end

  def by_month_calc_print(init_vals2, counter)
    puts "Highest Average: #{init_vals2[0] / counter}C"
    puts "Lowest Average: #{init_vals2[1] / counter}C"
    puts "Average Humidity: #{init_vals2[2] / counter}%"
  end

  def by_month_calc(init_vals2, result)
    counter = 0
    result.each do
      init_vals2[0] += result[counter][1].to_i
      init_vals2[1] += result[counter][3].to_i
      init_vals2[2] += result[counter][8].to_i
      counter += 1
    end
    by_month_calc_print(init_vals2, counter)
  end

  def by_month(path, year, month, bar_checker)
    result = []
    init_vals = []
    result = file_reader(result, dir_reader(path, year, month))
    init_vals += [[0, 0, 0], [0, 0]]
    if bar_checker == true
      by_month_bar_calc(init_vals[1], result)
    else
      by_month_calc(init_vals[0], result)
    end
  end

  def by_month_bar_calc(init_vals3, result)
    counter = 0
    result.each do
      init_vals3[0] = result[counter][1].to_i
      init_vals3[1] = result[counter][3].to_i
      bar_printer(counter + 1, '+', init_vals3[0], init_vals3[1])
      counter += 1
    end
  end

  def month_get(arguments, bar_checker)
    arr = arguments[1].split('/')
    arr[1] = month_assigner(arr[1])
    by_month(arguments[2], arr[0], arr[1], bar_checker)
  end
end
