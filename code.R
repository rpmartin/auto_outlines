library("lubridate")
library("tidyverse")
##########things that change. 
sections <- c("A01","A02")
term <- 202201
first_friday <- ymd("2022-01-14")
crns <- list(A01="21087, 21540",A02="21088, 21501")
time_of_day <- list(A01="11:30am", A02="1:30pm")
office_hours <- list(A01="12:30pm",A02="12:30pm")
deadline <- "11:59pm"
############things that stay the same.
course <- "Econ381"
codes <- "ECON 381, ES 312"
instructor <- "Richard Martin"
email <- "rpmartin@uvic.ca"
assignment <- 5
participation <- 2
presentation <- 14
essay <- 40
########### assessment calendar
assessment <- tibble(date=c(first_friday+weeks(1:4),first_friday+weeks(3:5), first_friday+weeks(7), first_friday+weeks(8:10),first_friday+weeks(9:12)))%>%
  arrange(date)%>%
  mutate(day= wday(date, label = TRUE, abbr=FALSE),
         thing=c("Experiment 1",
                 "Experiment 2",
                 "Experiment 3",
                 "Assignment 2",
                 "Experiment 4",
                 "Assignment 3",
                 "Assignment 4",
                 "Presentation",
                 "Experiment 5",
                 "Experiment 6",
                 "Assignment 5",
                 "Experiment 7",
                 "Assignment 6",
                 "Assignment 7",
                 "Essay"),
         worth=c(rep(2,3),5,2,5,5,16,2,2,5,2,5,5,40),
         worth=paste0(worth,"%")
                 )%>%
  select(thing,worth,day,date)
  

########## generate outlines and slides for all sections. 
for (i in sections){
  details <- tibble(`course codes:`=codes,
                      `section:`=i,
                      `CRNs:`=crns[[i]],
                      `instructor:`=instructor,
                      `lectures:`=paste("TWF at",time_of_day[[i]],sep=" "),
                      `office hours:`=paste("TWF at",office_hours[[i]],sep=" "),
                      `email:`=email)
  assessment <- assessment%>%
    mutate(time=c(time_of_day[i],
                  time_of_day[i],
                  time_of_day[i],
                  deadline,
                  time_of_day[i],
                  deadline,
                  deadline,
                  deadline,
                  time_of_day[i],
                  time_of_day[i],
                  deadline,
                  time_of_day[i],
                  deadline,
                  deadline,
                  deadline))
   colnames(assessment) <- str_to_title(colnames(assessment))          
  
  rmarkdown::render(input="econ381.Rmd", 
                    output_format = "pdf_document", 
                    output_file = paste(course,term,i,".pdf",sep="_"), 
                    params=list(details=details,assessment=assessment))

  rmarkdown::render(input="econ381.Rmd",
                    output_format = "beamer_presentation",
                    output_file = paste(course,term,i,"slides.pdf",sep="_"), 
                    params=list(details=details,assessment=assessment))
}
