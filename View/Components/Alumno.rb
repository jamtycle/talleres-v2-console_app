#require 'tty-prompt'
Dir["./Model/*.rb"].each {|file| require file }

class Alumno < ModelView

	def initialize()
		super
		@choices.push({name: "Ver Notas", value: :custom})
	end

	def getControl()
		super
		case @option
			when :custom
				return VerNotas()
		end
	end

	#CRUD METHODS
	private

	def VerNotas()
		filter = @promt.ask("Filtro: ")	do |q|
			q.validate /[0-9]/
			q.convert :int
		end

		data = GetReadUrl("#{CRUD::DefUri}/alumno/#{filter}/getNotas")
		
		#puts data[0].keys
		#return

		begin

			data.each { |row| 
				final = 0
				case row["tipoTaller"]
					when "teorico"
						#(EVA1 * 0.25) + (EVA2 * 0.25) + (EXAMEN FINAL * 0.5)
						final = Float((Float(row["eval1"]) * 0.25) + (Float(row["eval2"]) * 0.25) + (Float(row["evalFinal"]) * 0.5))

					when "practico"
						#(EVA1 * 0.2) + (EVA2 * 0.2) + (EXAMEN FINAL * 0.6)
						final = Float((Float(row["eval1"]) * 0.2) + (Float(row["eval2"]) * 0.2) + (Float(row["evalFinal"]) * 0.6))
						
					when "blended"
						#(EVA1 * 0.15) + (EVA2 * 0.15) + (VIRTUAL * 0.2) + (EXAMEN FINAL * 0.5)
						final = Float((Float(row["eval1"]) * 0.15) + 
								(Float(row["eval2"]) * 0.15) + 
								(Float(row["evalVirtual"]) * 0.2) + 
								#(13.5 * 0.2) + 
								(Float(row["evalFinal"]) * 0.5))
				end

				row.store("nota_final", final.round(2))
				row["eval1"] = Float(row["eval1"])
				row["eval2"] = Float(row["eval2"])
				row["evalVirtual"] = Float(row["evalVirtual"])
				row["evalFinal"] = Float(row["evalFinal"])
			}

			RenderTable(data)
		rescue => e
			puts e.message
		end
	end	

	def Create()
		data = {}
		data[:nombre] = @promt.ask("Nombre: ") do |q| q.required true; end;
		data[:apellido] = @promt.ask("Apellido: ") do |q| q.required true; end;
		data[:email] = @promt.ask("Email: ") do |q| q.required true; end;
		data[:password] = @promt.ask("Contraseña: ") do |q| q.required true; end;

		super(data.to_json)
	end

	def Read()
		filter = @promt.ask("Filtro: ")	do |q|
			q.validate /[0-9]/
			q.convert :int
		end

		super(filter)
	end
end