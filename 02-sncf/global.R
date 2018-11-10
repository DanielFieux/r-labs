message('read data')

# https://www.data.gouv.fr/fr/datasets/repartition-par-age-de-l-effectif-sncf/
# https://www.data.gouv.fr/fr/datasets/r/077cedaa-9a31-4b62-981f-81da42f21bf7

dirFile = Sys.getenv('SHINY-SNCF-PATH')
if (dirFile == "") {
  targetFile = 'repartition-age-effectif.csv'
} else {
  targetFile = paste(dirFile, 'repartition-age-effectif.csv', sep="/")
}

if (! file.exists(targetFile)) {
  message(' get file from internet')
  download.file('https://www.data.gouv.fr/fr/datasets/r/077cedaa-9a31-4b62-981f-81da42f21bf7',
                targetFile,
                cacheOK = TRUE,
                quiet = TRUE)
}

message(paste(' get the file from local source', targetFile))
# load the file from the csv source
dAge <- read.csv(targetFile,
                 sep=';',
                 encoding = "UTF-8")

# change column names which are not practical
names(dAge) <- c('date', 'contrat', 'college', 'age', 'effectif')