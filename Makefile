compile:
	@./rebar compile

dialyze: compile
	dialyzer --plt dialyzer.plt \
	-c ebin

build-plt:
	dialyzer --build_plt \
	--output_plt dialyzer.plt \
	--apps kernel stdlib sasl erts tools crypto compiler
