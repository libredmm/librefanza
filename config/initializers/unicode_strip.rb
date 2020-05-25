class String
  def strip
    self&.gsub(/^[[:space:]]+|[[:space:]]+$/, '')
  end
end