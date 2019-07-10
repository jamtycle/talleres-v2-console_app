Dir["./Model/*.rb"].each {|file| require file }

class Matricula < ModelView

	def initialize()
		super
		@choices = [
		  {name: "Ver Matricula", value: CRUD::Read},
		  {name: "Nueva matrícula", value: CRUD::Create},
		  {name: "Registrar Nota", value: :setNota}
		]
	end

	def getControl()
		super
		case @option
			when :setNota
				return setNota()
		end
	end

	#CRUD METHODS
	private

	def setNota()
		data = {}
		data[:codigoAlumno] = @promt.ask("Cod. Alumno: ") do |q| q.required true; q.convert :int; end;
		data[:codigoTaller] = @promt.ask("Cod. Taller: ") do |q| q.required true; q.convert :int; end;
		data[:tipoEval] = @promt.select("Tipo de Taller: ", active_color: :cyan) do |menu| 
			menu.choice 'Evaluación 1', 'eval1'
  			menu.choice 'Evaluación 2', 'eval2'
  			menu.choice 'Evaluación Virtual', 'evalVirtual'
  			menu.choice 'Evaluación Final', 'evalFinal'
		end

		data[:nota] = @promt.ask("Nota: ") do |q| q.validate /[0-9]+(\.[0-9][0-9]?)?/; q.required true; q.convert :float; end;

		#puts data.to_json	

		CreateUrl("#{CRUD::DefUri}/matricula/setNota", data.to_json)
	end	

	def Create()
		data = {}
		data[:codigo_alumno] = @promt.ask("Cod. Alumno: ") do |q| q.required true; q.convert :int; end;
		data[:codigo_taller] = @promt.ask("Cod. Taller: ") do |q| q.required true; q.convert :int; end;

		super(data.to_json)
	end

	def Read()
		cod_alumno = @promt.ask("Cod. Alumno: ") do |q| q.validate /[0-9]/; q.convert :int; end;
		cod_taller = @promt.ask("Cod. Taller: ") do |q| q.validate /[0-9]/; q.convert :int; end;

		data = GetReadUrl("#{CRUD::DefUri}/get#{self.class}/#{cod_alumno}/#{cod_taller}")

		begin

			data.each { |row| 
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
end