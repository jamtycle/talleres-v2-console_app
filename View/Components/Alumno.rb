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

		uri = URI.parse("#{CRUD::DefUri}/alumno/#{filter}/getNotas")
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