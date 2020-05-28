module Fanza
  class Id
    def self.normalize(id)
      return nil unless id

      alphas_regex = /(3dsvr|\D+)/i
      groups = id.gsub("-", "").gsub(/^._/i, "").gsub(/[^a-z0-9]/i, "").split(alphas_regex).reject(&:empty?)
      groups.shift if groups.first =~ /^\d+$/
      groups.pop if groups.last =~ alphas_regex

      digit_idx = groups.each_with_index.select { |g, i|
        g =~ /^\d+$/
      }.map { |g, i|
        [g.length, i]
      }.max&.last
      return id unless digit_idx

      alpha_idx = groups.each_with_index.select { |g, i|
        (i < digit_idx) && (g =~ /^(3dsvr|\D+)$/i)
      }.map { |g, i|
        [g.length, i]
      }.max&.last
      return id unless alpha_idx

      digit = groups[digit_idx]
      digit = "%03d" % digit.to_i if digit.length != 2
      special_transform "#{groups[alpha_idx...digit_idx].join.upcase}-#{digit}"
    end

    def self.normalized?(id)
      case id
      when /^[a-z]+-\d+$/i,
           /^T28-\d{3}$/i,
           /^3DSVR-\d{3}$/i
        true
      else
        false
      end
    end

    def self.variations(id)
      variations = Set[id]
      return variations unless normalized?(id)

      alphas, digits = id.split("-")
      variations << ("%s%03d" % [alphas, digits.to_i]).downcase
      variations << ("%s%05d" % [alphas, digits.to_i]).downcase
      variations
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
