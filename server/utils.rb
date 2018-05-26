#coding: utf-8
require 'digest/md5'

module Utils
  def rand_str n
    str = [('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
    (0...n).map{ str[rand(str.length)]}.join
  end

  def get_json(file_name)
    if File.exist?(file_name)
      begin
        return JSON.parse(File.read(file_name))
      rescue => e
        raise e, "Failed to parse json file #{file_name}"
      end
    else
      raise "File #{file_name} not found"
    end
  end
end