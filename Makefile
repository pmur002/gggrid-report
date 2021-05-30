
TARFILE = ../gggrid-deposit-$(shell date +'%Y-%m-%d').tar.gz
## Requires R 4.1 for radial gradient (at least)
## Rscript = ~/R/r-devel/BUILD/bin/Rscript
Rscript = Rscript

%.xml: %.cml %.bib
	# Protect HTML special chars in R code chunks
	$(Rscript) clean.R $*.cml
	$(Rscript) toc.R $*.xml
	$(Rscript) bib.R $*.xml
	$(Rscript) foot.R $*.xml
	## Replace any -- (that are neither <!-- nor -->) with &#x002D;
	## For XSL processing (.xml -> .Rhtml)
	$(Rscript) -e 'x <- readLines("$*.xml"); writeLines(gsub("([^!])--([^>])", "\\1&#x002D;&#x002D;\\2", x), "$*.xml")'

%.Rhtml : %.xml
	# Transform to .Rhtml
	xsltproc knitr.xsl $*.xml > $*.Rhtml
	## Reverse transform &#002D;&#002D; -> -- (post XSL processing)
	## AND make sure <!--begin.rcode is on its own line
	## For 'knitr' processing (.Rhtml -> .html)
	$(Rscript) -e 'x <- readLines("$*.Rhtml"); writeLines(gsub("&#x002D;&#x002D;", "--", gsub("><!--begin.rcode", ">\n<!--begin.rcode", x)), "$*.Rhtml")'

%.html : %.Rhtml
	# Use knitr to produce HTML
	$(Rscript) knit.R $*.Rhtml
	# Remove wonky LaTeX commands that knitr is inserting in HTML output
	$(Rscript) -e 'x <- readLines("$*.html"); writeLines(gsub("^\\\\let\\\\hlesc\\\\hlstd.+", "", x), "$*.html")'

docker:
	cp ../../gggrid_0.1-0.tar.gz .
	sudo docker build --network=host -t pmur002/gggrid .
	sudo docker run --net=host -v $(shell pwd):/home/work/ -w /home/work --rm pmur002/gggrid make gggrid.html

web:
	make docker
	cp -r ../gggrid-report/* ~/Web/Reports/gggrid/

zip:
	make docker
	tar zcvf $(TARFILE) ./*
