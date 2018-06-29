library(ReadPDF)
library(XML)

xml = list.files(pattern = "\\.xml$", recursive = TRUE, full = TRUE)
docs = lapply(xml, readPDFXML)
names(docs) = xml

err = xml[!(scanned %in% c("TRUE", "FALSE"))]
c("./Australian Bat Lyssavirus/Richmond-2014.xml", "./Cache Valley Virus/Johnson-2014.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Champour-2016 2.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Schuster-2016.xml", 
"./Getah Virus/Nemoto-2016.xml")

scannedDocs = xml[scanned == "TRUE"]
# 148

c("./Adam.xml", "./Barmah Forest Virus/Humphery-Smith-1991.xml", 
"./Barmah Forest Virus/Vale-1991.xml", "./Black Creek Canal Virus/Khan-1996.xml", 
"./Black Creek Canal Virus/Ravkov-1995.xml", "./Black Creek Canal Virus/Rollin-1995.xml", 
"./Cache Valley Virus/Belle-1980.xml", "./Cache Valley Virus/Buescher-1970.xml", 
"./Cache Valley Virus/Calisher-1986.xml", "./Cache Valley Virus/Chung-1990.xml", 
"./Cache Valley Virus/Edwards-1989.xml", "./Cache Valley Virus/McConnell-1987.xml", 
"./Cache Valley Virus/McLean-1985.xml", "./Cache Valley Virus/Yuill-1970.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Guilherme-1996.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Hassanein-1997.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Mariner-1995.xml", "./Crimean Congo Hemorrhagic Fever Virus/Rechav-1986.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Shepherd-1987 2.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Shepherd-1987 3.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Shepherd-1987.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Swanepoel-1983.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Swanepoel-1985 2.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Swanepoel-1985.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Swanepoel-1987.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Yen-1985.xml", "./Crimean Congo Hemorrhagic Fever Virus/Zeller-1994.xml", 
"./Crimean Congo Hemorrhagic Fever Virus/Zeller-1997.xml", "./Dobrava Virus/Antoniadis-1996.xml", 
"./Dobrava Virus/Avsiczupanc-1992.xml", "./Dobrava Virus/Burek-1994.xml", 
"./Dobrava Virus/Dzagurova-1995.xml", "./Duvenhage Virus/Fekadu-1988.xml", 
"./El Moro Canyon Virus/Rawlings-1996.xml", "./European Bat Lyssavirus 1/Perez-Jorda-1995.xml", 
"./European Bat Lyssavirus 2/Whitby-1996.xml", "./European Bat Lyssavirus 2/Whitby-2000.xml", 
"./field.xml", "./Getah Virus/Fukunaga-1981.xml", "./Getah Virus/Imagawa-1981.xml", 
"./Getah Virus/Kamada-1980.xml", "./Getah Virus/Kawamura-1987.xml", 
"./Getah Virus/Kumanomido-1986.xml", "./Getah Virus/Kumanomido-1988.xml", 
"./Getah Virus/Li-1992.xml", "./Getah Virus/Matsumura-1981.xml", 
"./Getah Virus/Mitchell-1993.xml", "./Getah Virus/Morita-1984.xml", 
"./Getah Virus/Sentsui-1985.xml", "./Getah Virus/Shibata-1991.xml", 
"./Getah Virus/Simpson-1976.xml", "./Getah Virus/Yago-1987.xml", 
"./Guaroa Virus/Groot-1959.xml", "./Guaroa Virus/Lee-1967.xml", 
"./Guaroa Virus/March-1967 2.xml", "./Guaroa Virus/March-1967.xml", 
"./Guaroa Virus/Whitman-1962.xml", "./Igbo-ora Virus/Olaleye-1988.xml", 
"./Isla Vista Virus/Song-1995.xml", "./Issyk-Kul/Lvov-1973.xml", 
"./Jamestown Canyon Virus/Aguirre-1992.xml", "./Jamestown Canyon Virus/Boromisa-1987.xml", 
"./Jamestown Canyon Virus/Campbell-1989.xml", "./Jamestown Canyon Virus/Clark-1986.xml", 
"./Jamestown Canyon Virus/Fulhorst-1996.xml", "./Jamestown Canyon Virus/Grimstad-1986.xml", 
"./Jamestown Canyon Virus/Grimstad-1987.xml", "./Jamestown Canyon Virus/Issel-1973.xml", 
"./Jamestown Canyon Virus/Issel-1974.xml", "./Jamestown Canyon Virus/McFarlane-1981.xml", 
"./Jamestown Canyon Virus/McLean-1996.xml", "./Jamestown Canyon Virus/Murphy-1989.xml", 
"./Jamestown Canyon Virus/Neitzel-1991 2.xml", "./Jamestown Canyon Virus/Neitzel-1991.xml", 
"./Jamestown Canyon Virus/Reisen-1995.xml", "./Jamestown Canyon Virus/Walker-1993.xml", 
"./Jamestown Canyon Virus/Zamparo-1997.xml", "./Kuzmin.xml", 
"./Lagos Bat Virus/Crick-1982.xml", "./Lagos Bat Virus/Mebatsion-1992.xml", 
"./Lagos Bat Virus/Mebatsion-1993.xml", "./Lagos Bat Virus/Oelofsen-1993.xml", 
"./Lagos Bat Virus/Ogunkoya-1990.xml", "./Lagos Bat Virus/Shope-1970.xml", 
"./Lagos Bat Virus/Shope-1982.xml", "./Lagos Bat Virus/Swanepoel-1993.xml", 
"./Lagos Bat Virus/Tignor-1974.xml", "./Mayaro Virus/Burlandy-2001.xml", 
"./Mayaro Virus/Calisher-1974.xml", "./Mayaro Virus/Hoch-1981.xml", 
"./Mayaro Virus/Seymour-1983.xml", "./Ockelbo Virus/Francy-1989.xml", 
"./Ockelbo Virus/Lord-1996.xml", "./Ockelbo Virus/Lundstrom-1991.xml", 
"./Ockelbo Virus/Lundstrom-1992.xml", "./Ockelbo Virus/Lundstrom-1993.xml", 
"./Ockelbo Virus/Shirako-1991.xml", "./Ockelbo Virus/Turell-1990.xml", 
"./Punta Toro Virus/Seymour-1983.xml", "./Rio Mamore Virus/Bharadwaj-1997.xml", 
"./Sandfly Fever Sicilian Virus/Saidi-1977.xml", "./Seoul Virus/Ahlm-1997-Prevalence of serum antibodies to ha.xml", 
"./Seoul Virus/Childs-1989-Effects of hantaviral infection on.xml", 
"./Seoul Virus/Childs-1991-HUMAN-RODENT CONTACT AND INFECTION.xml", 
"./Seoul Virus/Ibrahim-1996-Seroepidemiological survey of wil.xml", 
"./Seoul Virus/Kariwa-2000-Detection of hantaviral antibodies.xml", 
"./Seoul Virus/Kim-1994-Rapid differentiation between Hantaan.xml", 
"./Seoul Virus/Korch-1989-Serologic evidence of hantaviral in.xml", 
"./Seoul Virus/LeDuc-1986-Epidemiological investigations foll.xml", 
"./Seoul Virus/Lee-1996-Haemorrhagic fever with renal syndrom.xml", 
"./Seoul Virus/Lundkvist-1992-Bank vole monoclonal antibodies.xml", 
"./Seoul Virus/McCaughey-1996-Evidence of hantavirus in wild.xml", 
"./Seoul Virus/Morita-1994-Different transmissibility of 2 is.xml", 
"./Seoul Virus/Weigler-1996-Serological evidence for zoonotic.xml", 
"./Seoul Virus/Yoo-1993-Comparison of virulence between Seoul.xml", 
"./Tahyna Virus/Bardos-1974.xml", "./Tahyna Virus/Madic-1993.xml", 
"./Tahyna Virus/Mitchell-1993.xml", "./Toscana Virus/Verani-1988.xml", 
"./Tula Virus/Plyusnin-1994 2.xml", "./Tula Virus/Plyusnin-1994.xml", 
"./Tula Virus/Vapalahti-1996.xml", "./Western equine encephalitis/Aguirre-1992.xml", 
"./Western equine encephalitis/Artsob-1986.xml", "./Western equine encephalitis/Binninger-1980.xml", 
"./Western equine encephalitis/Bowen-1977.xml", "./Western equine encephalitis/Burton-1961 (1).xml", 
"./Western equine encephalitis/Burton-1961.xml", "./Western equine encephalitis/Calisher-1987.xml", 
"./Western equine encephalitis/Day-1996.xml", "./Western equine encephalitis/Dunbar-1998.xml", 
"./Western equine encephalitis/Ferreira-1994.xml", "./Western equine encephalitis/Gebhardt-1964.xml", 
"./Western equine encephalitis/Hayles-1972.xml", "./Western equine encephalitis/Holden-1973.xml", 
"./Western equine encephalitis/Hollister-1953.xml", "./Western equine encephalitis/Hopla-1993.xml", 
"./Western equine encephalitis/Iversson-1993.xml", "./Western equine encephalitis/Kissling-1957.xml", 
"./Western equine encephalitis/McLean-1979.xml", "./Western equine encephalitis/McLean-1989.xml", 
"./Western equine encephalitis/Merrell-1978.xml", "./Western equine encephalitis/Moreland-1979.xml", 
"./Western equine encephalitis/Prior-1971.xml", "./Western equine encephalitis/Scherer-1966.xml", 
"./Western equine encephalitis/Ubico-1995.xml", "./Western equine encephalitis/Vasconcelos-1991.xml", 
"./Western equine encephalitis/Zarnke-1981.xml")


# Some of these are duplicates

info = file.info(scannedDocs)
tmp = split(info, basename(rownames(info)))
w = sapply(tmp, nrow) > 1
# Only 3


ss = sample(scannedDocs, 10)
cmds = sprintf("make -f ~/Projects/OCR/Rtesseract/inst/Makefile/Makefile -C '%s' '%s'", dirname(ss), gsub("\\.xml$", ".jpg", basename(ss)))
sapply(cmds, system)

pageFiles = lapply(ss, function(f) list.files(dirname(f), full = TRUE, pattern = gsub("\\.xml", "_[0-9]+.jpg$", basename(f))))

library(Rtesseract)
bb1 = lapply(gsub("jpg$", "tiff", pageFiles[[1]]), GetBoxes)

