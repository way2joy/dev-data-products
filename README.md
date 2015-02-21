Rossi Criminal Recidivism Dataset
==================
This application explores the Rossi Criminal Recidivism dataset. The data pertains to 432 convicts who were released from Maryland state prisons in the 1970s and who were followed up for one year after release, with the outcome of interest being the time until the convicts returned to prison after release. Half the released convicts were assigned at random to an experimental treatment in which they were given financial aid; half did not receive aid. The dataset is available as part of the R package "RcmdrPlugin.survival" and more information is available [here](http://artax.karlin.mff.cuni.cz/r-help/library/RcmdrPlugin.survival/html/Rossi.html).
  
The dataset consists of 432 observations with 62 variables.
+ week: week of first arrest after release, or censoring time; all censored observations are censored at 52 weeks.
+ arrest: the event indicator, equal to 1 for those arrested during the period of the study and 0 for those who were not arrested.
  
Subset of covariates:
+ fin: a dummy variable coded 1 if the individual received financial aid and 0 if not.
+ age: in years at time of release.
+ race: a dummy variable coded 1 for blacks and 0 for others.
+ wexp: a dummy variable coded 1 if the individual had full-time work experience before incarceration and 0 if he did not.
+ mar: a dummy variable coded 1 if the individual was married at time of release and 0 if he was not.
+ paro: a dummy variable coded 1 if the individual was released on parole and 0 if he was not.
+ prio: number of convictions prior to current incarceration.
+ educ: level of education: 2 = 6th grade or less; 3 = 7th to 9th grade; 4 = 10th to 11th grade; 5 = 12th grade; 6 = some college.
  
  
#### Application Description
Source code is available at [GitHub](https://github.com/y1n9/DevDataProd), and the project presentation can be found on [RPubs](http://rpubs.com/y1n9/).
  
The application fits a Weibull parametric survival regression model to the Rossi recidivism dataset. The user inputs covariate values to obtain a prediction of the survival function based on the final model.
