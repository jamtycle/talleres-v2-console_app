require 'tty-prompt'
require 'tty-table'
require "rubygems"
require "net/https"
require "uri"
require "json"

class ModelView
	attr_reader :option
	def initialize()
		@promt = TTY::Prompt.new
		@choices = [
		  #{name: "Ver Notas", value: CRUD::Read},
		  {name: "Ver #{self.class}", value: CRUD::Read},
		  {name: "Nuevo #{self.class}", value: CRUD::Create}
		]
	end

	def ChoosingOption()
		puts "════════════════════════════ #{self.class} ════════════════════════════"
		@option = @promt.select("Escoja una opción: ", @choices)
		return self
	end	

	def getControl()
		case @option
			when CRUD::Create || CRUD::Update
				return Create()
			when CRUD::Read
				return Read()
		end
	end

	#CRUD METHODS
	private

	def CreateUrl(_url, _typo)
		uri = URI.parse(_url)
		#puts uri
		https = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.path)

		request.body = _typo
		#puts _typo

		res = https.request(request)
		jponse = JSON.parse(res.body)

		puts "Filas Afectadas: #{jponse["affectedRows"]}"		
	end

	def Create(_typo)
		uri = URI.parse("#{CRUD::DefUri}/create#{self.class}")
		https = Net::HTTP.new(uri.host, uri.port)
		#https.use_ssl = true
		request = Net::HTTP::Post.new(uri.path)

		#request['BODY'] = _typo
		request.body = _typo

		res = https.request(request)
		jponse = JSON.parse(res.body)

		puts "Filas Afectadas: #{jponse["affectedRows"]}"
	end

	def Read(_filter)
		uri = URI.parse("#{CRUD::DefUri}/get#{self.class}/#{_filter}")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		
		res = http.request(request)
		jponse = JSON.parse(res.body)

		arr = resultToArray(jponse["rows"])

		RenderTable(arr)
	end

	def resultToArray(results)
		_rows = []
		results.each do |row|
			_rows.push(row)
		end
		return _rows
	end

	def RenderTable(_arr)
		if(_arr.length == 0) then puts "No se encontró un #{self.class} con ese ID"; return end

		table = TTY::Table.new(header: _arr[0].keys)
		_arr.each { |hs| table << hs.values }
		puts table.render(:unicode, alignments: [:center, :center])
	end

	def PromptToJson()

	end
end