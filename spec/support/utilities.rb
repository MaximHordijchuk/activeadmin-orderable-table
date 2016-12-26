def entities_with_random_ordinal(count, random_ordinal_max)
  random_ordinals = (0...random_ordinal_max).to_a.sample(count)
  random_ordinals.map { |random_ordinal| Entity.new(ordinal: random_ordinal) }
end
