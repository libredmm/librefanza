module Fanza
  class Id
    def self.normalize(id)
      Id.new(id).normalized || id
    end

    def self.normalized?(id)
      Id.new(id).normalized != nil
    end

    def self.variations(id)
      Id.new(id).variations || Set[id]
    end

    def self.compress(id)
      Id.new(id).compressed || id
    end

    attr_reader :compressed, :normalized, :variations

    def initialize(original)
      @compressed = nil
      @normalized = nil
      @variations = nil

      return unless original.present?

      alphas_regex = /(3dsvr|\d\did|t28|r18|4k|\D+)/i
      groups = original.gsub("-", "").gsub(/^._/i, "").gsub(/[^a-z0-9]/i, "").split(alphas_regex).reject(&:empty?)
      groups.shift if groups.first =~ /^\d+$/
      groups.pop if groups.last =~ alphas_regex

      digit_idx = groups.each_with_index.select { |g, i|
        g =~ /^\d+$/
      }.map { |g, i|
        [g.length, i]
      }.max&.last
      return unless digit_idx

      alpha_idx = groups.each_with_index.select { |g, i|
        (i < digit_idx) && (g[alphas_regex] == g)
      }.map { |g, i|
        [g.length, i]
      }.max&.last
      return unless alpha_idx

      alphas = groups[alpha_idx...digit_idx].join.upcase
      digits = groups[digit_idx]

      @compressed = "#{alphas}-#{digits.to_i}"
      digits = "%03d" % digits.to_i if digits.length != 2

      if alphas == "T" && digits.length == 5 && digits.start_with?("28")
        alphas = "T28"
        digits = digits[2..-1]
      end
      @normalized = "#{alphas}-#{digits}"

      @variations = Set[
        @normalized,
        ("%s-%04d" % [alphas, digits.to_i]).upcase,
        ("%s%03d" % [alphas, digits.to_i]).downcase,
        ("%s%05d" % [alphas, digits.to_i]).downcase,
      ]
    end
  end
end
