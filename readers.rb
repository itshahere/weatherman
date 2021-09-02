# frozen_string_literal: true

require 'date'
require 'colorize'

class Readers
  def file_reader(result, dir_files)
    dir_files.each do |n|
      mode = 'r+'
      file = File.open(n, mode)
      result.concat(data_splitter(file))
    end
    result
  end

  def dir_reader(path, year, month)
    dir_files = []
    dir_files << Dir["#{path}/*#{year}*#{month}*.txt"]
    dir_files = dir_files.flatten
    if dir_files == []
      puts 'Data not found! Wrong path!'
      exit
    end
    dir_files
  end
end
