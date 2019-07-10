require 'tty-prompt'
Dir["./Model/*.rb"].each {|file| require file }
Dir["./Components/*.rb"].each {|file| require file }

class MainView

	def initialize()
		@menu = TTY::Prompt.new(interrupt: :signal)
	end

	def MainLoop()
		system('cls')
		puts CRUD::Titulo
		puts CRUD::UPC
		choices = [
		 	{name: 'Alumnos', value: Alumno.new},
		 	{name: 'Docente', value: Docente.new},
		 	{name: 'Taller', value: Taller.new},
		 	{name: 'Matricula', value: Matricula.new}
		]
		while true
			
			puts "════════════════════════════ Menú Principal ════════════════════════════"
			opt = @menu.select("Menú Principal: ", choices)
			system('cls')
			opt.ChoosingOption().getControl()

		end
	end
end

MainView.new().MainLoop()