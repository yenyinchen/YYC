Today we’re going to look at three functions that let you manipulate data frames, without the nasty side-effects of attach – with, within and transform.  

For adding (or overwriting) a column to a data frame, like in the above example, any of the three functions is perfectly adequate; they just have slightly different syntaxes. with often has the most concise formulation, though there isn’t much in it.  

...anorexia$wtDiff <- with(anorexia, Postwt - Prewt)  
*** anorexia <- within(anorexia, wtDiff2 <- Postwt - Prewt)
anorexia <- transform(anorexia, wtDiff3 = Postwt - Prewt)
For multiple changes to the data frame, all three functions can still be used, but now the syntax for with is more cumbersome. I tend to favour within or transform in these situations.

fahrenheit_to_celcius <- function(f) (f - 32) / 1.8
airquality[c("cTemp", "logOzone", "MonthName")] <- with(airquality, list(
  fahrenheit_to_celcius(Temp),
  log(Ozone),
  month.abb[Month]
))
airquality <- within(airquality,
{
  cTemp2     <- fahrenheit_to_celcius(Temp)
  logOzone2  <- log(Ozone)
  MonthName2 <- month.abb[Month]
})
airquality <- transform(airquality,
  cTemp3     = fahrenheit_to_celcius(Temp),
  logOzone3  = log(Ozone),
  MonthName3 = month.abb[Month]
)
The most important lesson to take away from this is that if you are manipulating data frames, then with, within and transform can be used almost interchangeably, and all of them should be used in preference to attach. For further refinement, I prefer with for single updates to data frames, and within or transform for multiple updates.
