Dir["./Model/*.rb"].each {|file| require file }

class Taller < ModelView

	def initialize()
		super
		@choices.push({name: "Talleres de Alumno", value: :getAlumnos})
		@choices.push({name: "Ver Todo", value: :getAll})
	end

	def getControl()
		super
		case @option
			when :getAlumnos
				return GetAlumnos()
			when :getAll
				return GetAll()
		end
	end

	#CRUD METHODS
	private

	def GetAlumnos()
		filter = @promt.ask("Filtro: ")	do |q|
			q.validate /[0-9]/
			q.convert :int
		end

		#http://159.203.181.159/alumno/1/getNotas
		ReadUrl("#{CRUD::DefUri}/taller/#{filter}/getAlumnos")
	end	

	def GetAll()
		ReadUrl("#{CRUD::DefUri}/getTalleres")
	end

	def Create()
		data = {}
		data[:nombre] = @promt.ask("Nombre: ") do |q| q.required true; end;
		data[:tipoTaller] = @promt.select("Tipo de Taller: ", active_color: :cyan) do |menu| 
			menu.choice 'teórico', 'teorico'
  			menu.choice 'práctico', 'practico'
  			menu.choice 'blended', 'blended'	
		end
		data[:codigo_docente] = @promt.ask("Cod. Docente: ") do |q| 
			q.validate /[0-9]/
			q.convert :int
		end

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