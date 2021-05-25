
## Execute as Rscript clean.R <filename>
args <- commandArgs()
extras <- grep("--args", args) + 1
filename <- args[extras[1]]

cml <- readLines(filename)
cleaned <- gsub("str>", "strong>",
                gsub("<rcode([^>]*)>", "<rcode\\1><![CDATA[",
                     gsub("</rcode>", "]]></rcode>",
                          gsub("<bash([^>]*)>", "<bash\\1><![CDATA[",
                               gsub("</bash>", "]]></bash>",
                                    cml)))))
writeLines(cleaned, gsub("[.]cml$", ".xml", filename))

