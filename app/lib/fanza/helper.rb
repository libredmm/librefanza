module Fanza
  class Helper
    def self.normalize_id(id)
      m = /\d*(?<alpha>[a-z]+)(?<digit>\d{3,})[a-z]*/.match(id)
      return id unless m
      "%s-%03d" % [m[:alpha].upcase, m[:digit].to_i]
    end
  end
end
