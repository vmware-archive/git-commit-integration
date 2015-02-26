module FactoryHelper
  def pad_zeros(number, places = 3)
    # left pad with zeros for sorting
    number.to_s.rjust(places, '0')
  end
end
