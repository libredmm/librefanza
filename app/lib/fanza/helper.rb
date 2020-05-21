module Fanza
  class Helper
    def self.normalize_id(id)
      m = /^(h_)?\d*(?<alpha>[a-z]+)(?<digit>\d+)[_a-z]*$/.match(id)
      return id unless m
      alpha = m[:alpha].upcase
      digit = m[:digit]
      digit = "%03d" % digit.to_i if digit.length > 3
      "#{alpha}-#{digit}"
    end
  end
end
