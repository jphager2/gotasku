module Gotasku
  module Tools
    
    extend self 

    def stringify(hash)
      hash.each_with_object({}) {|(k,v),h| h[k.to_s] = v}
    end
  end
end
