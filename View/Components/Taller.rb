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

		uri = URI.parse("#{CRUD::DefUri}/taller/#{filter}/getAlumnos")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		
		res = http.request(request)
		jponse = JSON.parse(res.body)

		arr = resultToArray(jponse["rows"])

		RenderTable(arr)
	end	

	def GetAll()
		uri = URI.parse("#{CRUD::DefUri}/getTalleres")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		
		res = http.request(request)
		jponse = JSON.parse(res.body)

		arr = resultToArray(jponse["rows"])

		RenderTable(arr)		
	end

	def Create()
		data = {}
		data[:nombre] = @promt.ask("Nombre: ") do |q| q.required true; end;
		data[:tipoTaller] = @promt.ask("Tipo de Taller: ") do |q| q.required true; end;
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