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
		data[:tipoEval] = @promt.ask("Evaluación: ") do |q| q.required true; end;
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

		uri = URI.parse("#{CRUD::DefUri}/get#{self.class}/#{cod_alumno}/#{cod_taller}")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		
		res = http.request(request)
		jponse = JSON.parse(res.body)

		arr = resultToArray(jponse["rows"])

		RenderTable(arr)
	end
end