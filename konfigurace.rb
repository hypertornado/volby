# encoding: UTF-8

NAMES = ["", "Roithová", "Fischer", "Bobošíková", "Fischerová", "Sobotka", "Zeman", "Franz", "Dientsbier", "Schwarzenberg"]

def load_configs
  ret = []

  [1,2,3,4,5,7,8].each do |i|
    [6,9].each do |j|
      ret.push({
        name: "#{NAMES[i]} > #{NAMES[j]}",
        p_proc: lambda {|el| el["1"]["platne"]},
        x_proc: lambda {|el| el["1"]["vysledky"][i.to_s]},
        y_proc: lambda do |el|
          el["2"]["vysledky"][j.to_s] - el["1"]["vysledky"][j.to_s]
        end
      })
    end
  end


  return ret
end





