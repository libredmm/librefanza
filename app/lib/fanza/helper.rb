module Fanza
  class Helper
    def self.normalize_id(id)
      id = id.gsub("-", "")
      m = /^([_a-z]*?\d+)??(?<alpha>[a-z]+)-?(?<digit>\d+)[_a-z]*(\d)?$/i.match(id)
      return id unless m
      alpha = m[:alpha].upcase
      digit = m[:digit]
      digit = "%03d" % digit.to_i if digit.length != 2
      "#{alpha}-#{digit}"
    end
  end
end
