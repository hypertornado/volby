  
require 'net/http'
require 'cobravsmongoose'
require 'json'

nuts = ["CZ010", "CZ020", "CZ031", "CZ032", "CZ041", "CZ042", "CZ051", "CZ052", "CZ053", "CZ063", "CZ064", "CZ071", "CZ072", "CZ080"]

candidates_sum = 9

task :download do
    system("rm -rf data; mkdir data")
    ["prez2013"].each do |type|
      [1,2].each do |round|
        nuts.each do |n|
          puts "#{type}_#{round}_#{n}"
          system("curl -o data/#{type}_#{round}_#{n} \"http://www.volby.cz/pls/#{type}/vysledky_kraj?kolo=#{round}&nuts=#{n}\"")
        end
      end
    end
end

task :prepare do
  all_obce = Hash.new()

  ["prez2013"].each do |type|
      [1,2].each do |round|
        nuts.each do |n|
          path = "data/#{type}_#{round}_#{n}"
          data = File.readlines(path).join("")
          h = CobraVsMongoose.xml_to_hash(data)
          kraj = h["VYSLEDKY_KRAJ"]["KRAJ"]
          kraj_id = kraj["@CIS_KRAJ"]
          kraj_name = kraj["@NAZ_KRAJ"]

          puts "#{round} - #{kraj_id} - #{kraj_name}"

          unless kraj["OKRES"].class == Array
            kraj["OKRES"] = [kraj["OKRES"]]
          end

          kraj["OKRES"].each do |okres|

            okres_id = okres["@CIS_OKRES"]
            okres_name = okres["@NAZ_OKRES"]

            okres["OBEC"].each do |obec|
              new_obec = {
                obec_id: obec["@CIS_OBEC"],
                obec_name: obec["@NAZ_OBEC"],
                okres_id: okres_id,
                okres_name: okres_name,
                kraj_id: kraj_id,
                kraj_name: kraj_name,
                zapsani: obec["UCAST"]["@ZAPSANI_VOLICI"].to_i,
                vydane: obec["UCAST"]["@VYDANE_OBALKY"].to_i,
                odevzdane: obec["UCAST"]["@ODEVZDANE_OBALKY"].to_i,
                platne: obec["UCAST"]["@PLATNE_HLASY"].to_i
              }


              vysledky = {}
              obec["HODN_KAND"].each do |kandidat|
                vysledky[kandidat["@PORADOVE_CISLO"].to_i] = kandidat["@HLASY"].to_i
              end

              1.upto(candidates_sum) do |i|
                vysledky[i] = 0 unless vysledky[i]
              end

              new_obec[:vysledky] = vysledky

              all_obce[obec["@CIS_OBEC"]] = {} unless all_obce[obec["@CIS_OBEC"]]

              all_obce[obec["@CIS_OBEC"]][round] = new_obec
            end

          end

        end
      end
    end

    f = File.new("results.json","w")

    f.write(all_obce.to_json)
end

task :correlation do
  require_relative "korelace.rb"
  require_relative "konfigurace.rb"
  c = Correlation.new()

  scored = []

  load_configs.each do |k|
    k[:result] = c.do_correlation(k[:p_proc], k[:x_proc], k[:y_proc])
    scored.push(k)
  end

  sorted = scored.sort_by {|k| k[:result]}

  sorted.reverse!

  sorted.each do |el|
    puts "#{el[:name]} - #{el[:result]}"
  end

end

