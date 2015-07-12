>fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
>setInternet2(use=TRUE)
>download.file(url=fileUrl,destfile="idaho_housing.csv",mode="w")
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
Content type 'text/csv' length 4246554 bytes (4.0 MB)
downloaded 4.0 MB
>list.files(".")
> dateDownloaded <- date()
> dateDownloaded 
[1] "Sat Jul 11 19:16:23 2015"

*** before I can use the data.table I need to download and install the package
install.packages("data.table")        # dowload and install it
library(data.table)                   #load

> idahoHousingData <- read.table("idaho_housing.csv", sep = ",", header = TRUE) ##Read file into memory
> idahoHousingDT <- data.table(idahoHousingData) ## Load into Data table

> idahoHousingDT[,.N,idahoHousingDT$VAL==24,]

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
>download.file(url=fileUrl,destfile="NGAP.xlsx",mode="wb") #download as binary

> install.packages("xlsx")
> library(xlsx)

> NGAPData <- read.xlsx("NGAP.xlsx",sheetIndex=1,header=TRUE)

rows 18-23 and columns 7-15
> colIndex <- 7:15
 rowIndex <- 18:23

> dat <- read.xlsx("NGAP.xlsx",sheetIndex=1, colIndex=colIndex,rowIndex=rowIndex,header=TRUE)
> sum(dat$Zip*dat$Ext,na.rm=T) 

install.packages("XML")
library(XML)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
## Issue reading the https url. Not supported by package? Workaround: download file and then read
## Alternatively, is possible, read the http url instead

rootNode <- xmlRoot(doc)
xmlName(rootNode)

lsZip <- data.table(xpathSApply(rootNode,"//zipcode",xmlValue))
lsZip[, .N, lsZip$V1==21231]


>fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
>download.file(url=fileUrl,destfile="housing.csv",mode="w")

DT <- data.table(fread("housing.csv", sep=",", header=TRUE))
install.packages("microbenchmark")
library(microbenchmark)
