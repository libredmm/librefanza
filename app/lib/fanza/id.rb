module Fanza
  class Id
    def self.normalize(id)
      return nil unless id

      groups = id.gsub("-", "").gsub(/^._/i, "").gsub(/[^a-z0-9]/i, "").split(/(\d+)/).reject(&:empty?)
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
      special_transform "#{groups[alpha_idx...digit_idx].join.upcase}-#{digit}"
    end

    def self.normalized?(id)
      id =~ /^[a-z]+-\d+$/i || id =~ /^T28-\d{3}$/i
    end

    private

    def self.special_transform(id)
      case id
      when /^T-28(00)?(\d{3})$/
        "T28-#{$2}"
      else
        id
      end
    end
  end
end
