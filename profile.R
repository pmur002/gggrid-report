
library(profvis)

source("rahlf-plot.R")
latex <- readLines("rahlf-text.tex")
library(gridGraphics)
grid.echo()
downViewport("graphics-plot-1")

Rprof("dvir-prof.out")

library(dvir)
grid.latex(latex, preamble="", postamble="", engine=luatexEngine, tinytex=FALSE,
           x=unit(1, "cm"), y=unit(1, "npc") - unit(1, "cm"), just=c("left", "top"))

## Had to "kill" the session, then hand modify the end of "dvir-prof.out"
## to remove an incomplete line
## Then skip the next line ...
Rprof(NULL)
## ... and, within a new R session, generate profvis report

p <- profvis(prof_input="dvir-prof.out")
## Full profiling output can be quite large
## awk -e 'NR < 20000 { print }' dvir-prof.out  > dvir-prof-sample.out
## p <- profvis(prof_input="dvir-prof-sample.out")

htmlwidgets::saveWidget(p, "dvir-prof.html")
