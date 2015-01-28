class String
  def is_number?
    true if Integer(self) else false
  end
end