rm(list=ls())
library("lubridate")
library("tidyverse")
##########things that change. 
sections <- c("A01","A02")
term <- 202101
first_friday <- ymd("2021-01-08")
crns <- list(A01="21044, 21483", A02="21045, 21484")
time_of_day <- list(A01="11:30am", A02="12:30pm")
############things that stay the same.
course <- "Econ381"
codes <- "ECON 381, ES 312"
instructor <- "Richard Martin"
email <- "rpmartin@uvic.ca"
zoom <- "arrange via email"
########### assessment calendar
assessment.dates<- c(first_friday-days(2),first_friday,first_friday+ weeks(0:13))
day.of.week <- strftime(assessment.dates,'%A')
name <- c(rep(c("experiment","assignment"),7))
num <- c(rep(0:6, each=2))
thing <- paste(name,num,sep=" ")
thing <- c(thing[1:8],"presentation",thing[9:14],"essay")
worth <- c(0,0,rep(c(2,13),3),10,rep(c(2,13),3),30)
########## generate outlines and slides for all sections. 
for (i in sections){
  details <- t(tibble(`course codes:`=codes,
                      `section:`=i,
                      `CRNs:`=crns[[i]],
                      `instructor:`=instructor,
                      `synchronous sessions:`=paste("Fridays at",time_of_day[[i]],sep=" "),
                      `email:`=email,
                      `zoom:`=zoom))
  colnames(details) <- ""
  time.of.day <- rep(time_of_day[[i]],16)
  assessment <- tibble(time=time.of.day,day=day.of.week,date=assessment.dates,thing=thing,`worth (%)`=worth)
  
  rmarkdown::render(input="econ381.Rmd", 
                    output_format = "pdf_document", 
                    output_file = paste(course,term,i,".pdf",sep="_"), 
                    params=list(details=details,assessment=assessment))

  rmarkdown::render(input="econ381.Rmd",
                    output_format = "beamer_presentation",
                    output_file = paste(course,term,i,"slides.pdf",sep="_"), 
                    params=list(details=details,assessment=assessment))
}
