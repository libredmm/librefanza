module Fanza
  class Helper
    def self.normalize_id(id)
      id = id.gsub("-", "")
      id = id.gsub(/^h_/i, "")
      groups = id.split(/(\d+)/).reject(&:empty?)
      groups.shift if groups.first =~ /\d+/
      groups.pop if groups.last =~ /\D+/

      digit_idx = groups.each_with_index.select { |g, i|
        g =~ /\d+/
      }.map { |g, i|
        [g.length, i]
      }.max&.last
      return id unless digit_idx

      alpha_idx = groups.each_with_index.select { |g, i|
        (i < digit_idx) && (g =~ /\D+/)
      }.map { |g, i|
        [g.length, i]
      }.max&.last
      return id unless alpha_idx

      digit = groups[digit_idx]
      digit = "%03d" % digit.to_i if digit.length != 2
      "#{groups[alpha_idx...digit_idx].join.upcase}-#{digit}"
    end
  end
end
