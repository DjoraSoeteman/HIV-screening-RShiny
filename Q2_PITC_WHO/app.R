library(shiny)
library(shinythemes)
library(readxl)
ui<-fluidPage(
  theme=shinythemes::shinytheme ("cosmo"),
  titlePanel("Clinical and Economic Value of Provider-Initiated HIV Testing and Counseling (PITC) in Children"),
  sidebarLayout(
  sidebarPanel(
    helpText("Use the dropdown menu to create a population profile. Base case values for South Africa are displayed."),
  # Copy the line below to make a select box 
  selectInput("Prev", label = h5("Pediatric undiagnosed HIV prevalence (%)", style = "color:steelblue"), 
              choices = list("0" = 0, "0.1" = 0.1, "0.2" = 0.2, "0.3" = 0.3, "0.4" = 0.4, "0.5" = 0.5, "1" = 1, "2" = 2, "3" = 3, "4" = 4, "5" = 5, "7.5" = 7.5, "10" = 10, "12.5" = 12.5, "15" = 15, "17.5" = 17.5, "20" = 20), 
              selected = 0.1),
  # Copy the line below to make a select box 
  selectInput("Accept", label = h5("PITC test acceptance rate (%)", style = "color:steelblue"), 
              choices = list("60" = 0.6, "80" = 0.8, "100" = 1), 
              selected = 0.6),
  # Copy the line below to make a select box 
  selectInput("Link", label = h5("Linkage to care/ART after PITC test (%)", style = "color:steelblue"), 
              choices = list("50" = 0.5, "70" = 0.7, "100" = 1), 
              selected = 0.5),
  # Copy the line below to make a select box 
  selectInput("Testcost", label = h5("PITC test cost (USD)", style = "color:steelblue"), 
              choices = list("0" = 0, "5" = 5, "10" = 10, "15" =15, "25" = 25, "35" = 35), 
              selected = 10),
  # Copy the line below to make a select box 
  selectInput("ARTcost", label = h5("HIV care and ART costs (USD)", style = "color:steelblue"), 
              choices = list("base case" = 0, "0.1x" = 0.1, "0.5x" = 0.5, "2x" = 2), 
              selected = 0)),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel(strong("About this tool", style = "color:steelblue"),
                         br(),
                         p("This webtool is designed to estimate clinical outcomes and cost-effectiveness of provider-initiated HIV testing and counseling (PITC) compared to no PITC in a cohort of children between 2-10 years-old, comprised of HIV-unexposed, HIV-exposed uninfected, and HIV-infected children, in a given country in a given year. The tool allows the user to select a combination of input parameters that might reflect a range of clinical settings.", style = "color:grey"),
                         h5(strong("Competing strategies")),
                         p("The HIV testing strategies that are evaluated include:", style = "color:grey"),
                         p("(1) All children are routinely offered one-time HIV testing at the start of the simulation (“PITC”);", style = "color:grey"),
                         p("(2) No routine HIV test is offered at the start of the simulation (“No PITC”).", style = "color:grey"),
                         p("In both strategies, children may present later with an opportunistic infection, or they may be detected through a background test.", style = "color:grey"),
                         h5(strong("Cost-effectiveness")),
                         p("The cost-effectiveness results show the incremental cost-effectiveness ratio (ICER) of PITC compared with no PITC in a pediatric population. The ICER is calculated by the difference in cost between the two strategies, divided by the difference in their health effect. It expresses how much one needs to pay for one additional year of life saved (YLS).", style = "color:grey"),
                         p("An ICER below $547 per YLS (assumption for South Africa [1]) indicates that PITC can be considered a cost-effective strategy and a negative ICER (with positive health effects) indicates that PITC is cost-saving.", style = "color:grey"),
                         br()),
                tabPanel(strong("Parameter descriptions", style = "color:steelblue"),
                         br(),
                         wellPanel(h5(strong("Pediatric undiagnosed HIV prevalence (%):")),
                                   p("The proportion of children presenting to a given clinical setting with previously undiagnosed HIV.", style = "color:grey"),
                                   br(),
                                   h5(strong("PITC test acceptance rate (%):")),
                                   p("Proportion of patients/caregivers who accept routine PITC.", style = "color:grey"),
                                   br(),
                                   h5(strong("Linkage to care/ART after PITC test (%):")),
                                   p("Following PITC, probability of receiving test results and, if positive, linking to HIV care and initiating ART.", style = "color:grey"),
                                   br(),
                                   h5(strong("PITC test cost (USD):")),
                                   p("Cost of PITC test to detect pediatric HIV (including test kits for first and confirmatory tests, as well as healthcare worker time for counseling, testing, and result return).", style = "color:grey"),
                                   br(),
                                   h5(strong("HIV care and ART costs (USD):")),
                                   p("Monthly costs of care for HIV treatment, including outpatient care, inpatient care, and ART. The “base case” value reflects the costs of care in South Africa and the costs of LPV/r-based first-line pediatric ART from the Clinton Health Access Initiative. The multipliers allow the user of the tool to vary these costs to be higher or lower.", style = "color:grey"))),
                tabPanel(strong("Cost-effectiveness", style = "color:steelblue"),
                        br(),
                        wellPanel(h5(strong("Incremental cost-effectiveness ratio")),
                                   textOutput("selected_var1"),
                                   br(),
                                   h5(strong("PITC (as compared to no PITC) leads to:")),
                                   textOutput("selected_var2"),
                                   textOutput("selected_var3")),
                         fluidRow(column(width=7,plotOutput("plot2",height=350, width=600))),
                         br()),
                tabPanel(strong("Clinical outcomes", style = "color:steelblue"), 
                         br(),
                        column(5,plotOutput("plot1", width = 600, height = 350))),
                tabPanel(strong("More information", style = "color:steelblue"),
                         br(),
                         h5(strong("CEPAC-Pediatric model", style = "#75AADB")),
                         p("The Cost-Effectiveness of Preventing AIDS Complications (CEPAC)-Pediatric model is a first-order, Monte Carlo simulation model of infant HIV infection, disease progression, diagnosis, and treatment. Technical details of the CEPAC-Pediatric model, including model flowcharts, key assumptions, sample code, and data inputs, are available in published work and on the CEPAC website [2-5; link to website: https://www.massgeneral.org/medicine/mpec/research/cpac-model].", style = "color:grey"),
                         p("For this analysis, we simulated a cohort of children between 2-10 years-old, comprised of HIV-unexposed, HIV-exposed uninfected, and HIV-infected children, in a given country in a given year. A virtual cohort of 10 million children was simulated in order to achieve stable model output. We examined two strategies: (1) All children are routinely offered one-time HIV testing at the start of the simulation (“PITC”); and (2) No routine HIV test is offered at the start of the simulation (“no PITC”). In both strategies, children may present later with an opportunistic infection, or they may be detected through a background test. We applied an annual discount rate of 3% for both health effects and cost.", style = "color:grey"),
                         br(),
                         h5(strong("Acknowledgements", style = "#75AADB")),
                         p("This web tool was designed by Djøra Soeteman, with financial and technical support from the World Health Organization (WHO). We would like to thank the collaborating investigators and members of the WHO-CEPAC Infant Testing Steering Committee. Additional longstanding support for development of the CEPAC models in the Medical Practice Evaluation Center at Massachusetts General Hospital, Boston, MA, USA has been provided by the Eunice Kennedy Shriver National Institute of Child Health and Human Development [R01HD079214, K08 HD094638] and the National Institute of Allergy and Infectious Diseases [K01 AI078754, R37AI058736, R37AI093269, T32AI007433]. The content is solely the responsibility of the authors and does not necessarily represent the official views of the World Health Organization or the National Institutes of Health.", style = "color:grey"),
                         br(),
                         h5(strong("References", style = "#75AADB")),
                         p("[1] Meyer-Rath G, van Rensburg C, Larson B, Jamieson L, Rosen S. Revealed willingness-to-pay versus standard cost-effectiveness thresholds: Evidence from the South African HIV Investment Case. PLoS One. 2017;12(10):e0186496.", style = "color:grey"),
                         p("[2] Francke JA, Penazzato M, Hou T, et al. Clinical impact and cost-effectiveness of diagnosing HIV infection during early infancy in South Africa: Test timing and frequency. J Infect Dis 2016;214(9):1319-28.", style = "color:grey"),
                         p("[3] Frank SC, Cohn J, Dunning L, et al. Clinical effect and cost-effectiveness of incorporation of point-of-care assays into early infant HIV diagnosis programmes in Zimbabwe: a modelling study. Lancet HIV. 2019 Mar;6(3):e182-e190.", style = "color:grey"),
                         p("[4] Dunning L, Francke JA, Mallampati D, et al. The value of confirmatory testing in early infant HIV diagnosis programmes in South Africa: A cost-effectiveness analysis. PLoS Med 2017;14(11):e1002446.", style = "color:grey"),
                         p("[5] Ciaranello AL, Doherty K, Penazzato M, et al. Cost-effectiveness of first-line antiretroviral therapy for HIV-infected African children less than 3 years of age. AIDS 2015;29(10):1247-59.", style = "color:grey"),
                         br()))
)))
#Define the server code
server<-function(input, output) {
library(readxl)
data_work <- read_excel("data/data_work_v2.xlsx")
output$selected_var1<-renderText({
    # Incremental cost-effectiveness ratio
myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="no test")
    x1<-myRow$ICER[1]
    paste("- Among HIV infected and uninfected children, PITC compared to no PITC:",round(x1,digits=0),"per YLS")
  })
output$selected_var2<-renderText({
  # Life expectancy (discounted)
  myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="no test")
  x1<-myRow$LE[1]
  myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  x2<-myRow$LE[1]
  paste("- Life expectancy (discounted): Mean improvement of",round(x2-x1,digits=4),"years")
})
output$selected_var3<-renderText({
  myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="no test")
  x1<-myRow$Costs[1]
  myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  x2<-myRow$Costs[1]
  paste("- Lifetime HIV-related costs (discounted): Reduction of US$",round(x2-x1,digits=0))
})
output$selected_var4<-renderText({
  # One-year survival
  x1<-16
  paste("- One year survival:",round(x1,digits=0),"deaths avoided per 100,000 children")
})
output$selected_var5<-renderText({
  # Life expectancy (undiscounted)
  x1<-16
  paste("- Life expectancy (undiscounted): Mean improvement of",round(x1,digits=1),"years")
})
output$selected_var6<-renderText({
  # HIV-related costs (undiscounted)
  x1<-16
  paste("- Lifetime HIV-related costs (undiscounted): Reduction of US$",round(x1,digits=0))
})
output$selected_var7<-renderText({
  # HIV RNA suppressed at 5 years
  x1<-16
  paste("- HIV RNA suppressed at 5 years: Improvement of",round(x1,digits=0),"per 100,000 children")
})
output$selected_var8<-renderText({
  # Number of new HIV diagnoses
  x1<-16
  paste("- New HIV diagnoses:",round(x1,digits=0),"additional children diagnosed with HIV per 100,000 children")
})
output$selected_var9<-renderText({
  # CD4 at ART initiation
  x1<-16
  paste("- CD4 at ART initiation: Mean improvement of",round(x1,digits=0), "cells/mm3")
})
output$plot1 <- renderPlot({
  myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  #print(myRow)
  x1<-myRow$Status[1]
  x2<-myRow$Tx[1]
  x3<-myRow$Suppressed[1]
  myRow<-subset(data_work,input$Prev==Prevalence & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="no test")
  x4<-myRow$Status[1]
  x5<-myRow$Tx[1]
  x6<-myRow$Suppressed[1]
  par(oma = c(2, 1, 1, 1))
  labs=c("","")
  x<-barplot(as.matrix(c(x1,x2,x3,x4,x5,x6),nr=3),beside = T, ylim=c(0,100),ylab="Percent", xlab="",col=c("grey","#75AADB","firebrick3"), border='white', main="One-year cascade of care",names=c("","PITC","","","No PITC",""),cex.names=1.2,font=2,col.axis="#75AADB",yaxt="n",space=c(0,0,0,2,0))
  axiscolors=c("grey","#75AADB","#75AADB","grey","#75AADB","#75AADB")
  Map(function(x,y,z)
    axis(1,at=x,col.axis=y,labels=z,lwd=0,font=2),
    2.5:1.5,axiscolors,labs)
  axis(1,at=1:2,labels=FALSE,lwd=0)
  axis(side=2)
  text(x,0,pos=3,col="white",font=2,cex=1.2,labels=round(c(x1,x2,x3,x4,x5,x6),digits=1))
  mtext(x,0,"",1)
  par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
  plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
  legend("bottomleft", c("Children living with HIV who know their status", "Children living with HIV who are on treatment/ART","Children living with HIV who are virally suppressed"), xpd = TRUE, horiz = FALSE, inset = c(0,0), bty = "n", pch = c(15,15), col = c("grey","#75AADB","firebrick3"), cex = 1)
  })
output$plot2 <- renderPlot({
  #myRow<-subset(data_work,Prevalence==0 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  #y1<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==0.1 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y2<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==0.2 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y3<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==0.3 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y4<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==0.4 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y5<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==0.5 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y6<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==1 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y7<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==5 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y8<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==10 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y9<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==15 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y10<- myRow$ICER[1]
  myRow<-subset(data_work,Prevalence==20 & input$Accept==Test_accept & input$Link==Linkage & input$Testcost == PITC_cost & input$ARTcost == HIV_ART_costs & Test=="test")
  y11<- myRow$ICER[1]
  y<-c(y2, y3, y4, y5, y6,y7,y8,y9,y10,y11)
  x<-c(0.1,0.2,0.3,0.4,0.5,1,5,10,15,20)
  plot(x,y,type="o",col="firebrick3",xlab="Undiagnosed HIV prevalence (%)",ylab="ICER ($/life year saved)",ylim=c(0,20000),xlim=c(0.1,20),frame=FALSE,main="ICER as a function of undiagnosed HIV prevalence",lwd=3, font.lab=2) 
  #lines(y,type="o",col="#75AADB",lwd=3, font.lab=2)
  axis(1,font=2)
  axis(2,font=2)
  #legend("topleft",legend=c("EID", "Screen and Test"),col=c("#75AADB","firebrick3"),lty=1:1,inset = c(0.1, 0.1),cex=1.0,box.lty = 0,text.font=2,lwd=3)
})
# You can access the value of the widget with input$select, e.g.
 output$value <- renderPrint({ input$select })
}
#Return a shiny app object
shinyApp(ui=ui,server=server)
