## Purpose of this script is to take a chequelist generated from the accounting software,
##    and compare it to the list of cheques that has been cashed (reported on the bank statement.)

## Load the reader Library
##  You will have to install teh readr library if it isn't already installed.
library(readr)

## Get the first list of cheques
a <- read_csv("a.csv")
import_a_sum = sum(a$amount)
View(a)

# Get the list of cheques from the bank. 
b <- read_csv("b.csv")
import_b_sum = sum(b$amount)
View(b)

## Merge the 2 lists.
## Outer join is all=TRUE
## http://www.datasciencemadesimple.com/join-in-r-merge-in-r/
t <- merge(a, b, by="num", all=TRUE)
View(t)

## Add a calculated column. 
## In case the wrong amount was charged. 
## The new column is named diff. 
## https://stackoverflow.com/questions/18999710/creating-a-new-column-to-a-data-frame-using-a-formula-from-another-variable
t$diff <- with(t, amount.x - amount.y)
View(t)


## Find out if there are duplicate cheque numbers. 
## It won't tell you wether the duplicate happened on the bank statement,
##  or the chequelist, but you should be able to tell this from the sum.
## https://stackoverflow.com/questions/6986657/find-duplicated-rows-based-on-2-columns-in-data-frame-in-r
t$dup <- with(t, duplicated(t[,1:2]))
View(t)

## Double-checks
## If the sum in dataframe t doesn't equal what was imported, there is a problem.
## https://stackoverflow.com/questions/9676212/how-to-sum-data-frame-column-values
check_a = import_a_sum  - sum(t$amount.x,na.rm=TRUE)
check_b = import_b_sum  - sum(t$amount.y,na.rm=TRUE)

if (check_a != 0){
  "There is a problem with a."
  check_a  
}

if (check_b != 0){
  "There is a problem with b."
  
}

## Write the output file 
## Set the NAs to blank
## https://stackoverflow.com/questions/20968717/write-a-dataframe-to-csv-file-with-value-of-na-as-blank
write.csv(t, file = "output.csv", na = "", row.names = TRUE)
