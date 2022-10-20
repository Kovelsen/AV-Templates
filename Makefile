images = logoUvA_en.pdf logoUvA_nl.pdf logoUvA_nl_xl.pdf
classes = uva-inf-article.cls uva-inf-bachelor-thesis.cls uva-inf-presentation.cls uva-inf-common.tex
template_target = /usr/share/uvalatex
source_target = /usr/share/texmf/tex/latex/uvalatex
executable = uvalatex.sh
completion_dir = /usr/share/bash-completion/completions

install: $(addprefix images/, $(images)) $(addprefix classes/, $(classes))
	mkdir -p $(template_target)
	mkdir -p $(source_target)
	cp -r templates $(template_target)
	cp -r images classes $(source_target)
	cp $(executable) /usr/bin/$(basename $(executable))
	if [ $$SHELL = "/bin/bash" ]; then make install_completion; fi
	texhash

install_completion:
	cp bashcomplete	$(completion_dir)/$(basename $(executable))

uninstall:
	-rm -r $(template_target)
	-rm -r $(source_target)
	-rm /usr/bin/$(basename $(executable))
	texhash

images/%.pdf: images/svg/%.svg
	-inkscape -z --file=$< --export-pdf=$@
