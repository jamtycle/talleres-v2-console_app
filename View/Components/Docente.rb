Dir["./Model/*.rb"].each {|file| require file }

class Docente < ModelView

	def initialize()
		super
		@choices.push({name: "Ver Talleres", value: :custom})
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

	def VerTalleres()
		filter = @promt.ask("Filtro: ")	do |q|
			q.validate /[0-9]/
			q.convert :int
		end

		ReadUrl("#{CRUD::DefUri}/docente/#{filter}/getTalleres")
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