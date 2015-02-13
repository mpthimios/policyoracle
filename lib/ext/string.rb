class String
  def is_number?
    /\A[-+]?\d+\z/ === self
  end
end