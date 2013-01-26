require "json"

class Correlation

	def initialize()
		f = File.open("results.json")
		@data = JSON.parse(f.readlines.join(""))
	end

	def do_correlation(p_proc, x_proc, y_proc)
		p_val = []
		x_val = []
		y_val = []

		@data.each do |k, v|
			#puts "\n\n"
			#puts v

			p_val.push(p_proc[v])
			x_val.push(x_proc[v])
			y_val.push(y_proc[v])



		end


		compute(p_val, x_val, y_val)
	end

	def compute(p_val, x_val, y_val)
		sum = p_val.inject{|sum,x| sum + x }
		p_val.map! {|i| i.to_f / sum}

		e_x = 0
		e_x_2 = 0
		e_y = 0
		e_y_2 = 0
		e_x_y = 0

		0.upto(p_val.length - 1) do |i|
			e_x += p_val[i] * x_val[i]
			e_x_2 += p_val[i] * x_val[i] * x_val[i]
			e_y += p_val[i] * y_val[i]
			e_y_2 += p_val[i] * y_val[i] * y_val[i]
			e_x_y += p_val[i] * x_val[i] * y_val[i]
		end

		if e_x_y == e_x * e_y
			result = 0
		else
			result = (e_x_y - ( e_x * e_y )) / (Math.sqrt(e_x_2 - (e_x * e_x)) * Math.sqrt(e_y_2 - (e_y * e_y)))
		end

		return result

	end

end