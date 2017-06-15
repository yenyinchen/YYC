
## R Markdown Cheetsheet  
https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf  
* An Example R Markdown  
http://rmarkdown.rstudio.com/authoring_basics.html  
https://help.github.com/categories/writing-on-github/  
http://www.statpower.net/Content/310/R%20Stuff/SampleMarkdown.html  
* Latex Symbol  
http://www.rpi.edu/dept/arc/training/latex/LaTeX_symbols.pdf  

---
# 100 FREE TUTORIALS FOR LEARNING R
* http://www.listendata.com/p/r-programming-tutorials.html


##  dplyr
* DPLYR TUTORIAL (WITH 50 EXAMPLES)  
http://www.listendata.com/2016/08/dplyr-tutorial.html
* dplyr 0.5 is awesome, here’s why  
https://blog.exploratory.io/dplyr-0-5-is-awesome-heres-why-be095fd4eb8a
* dplyr 0.5.0  
https://blog.rstudio.org/2016/06/27/dplyr-0-5-0/
* dplyr vs data.table  
https://stackoverflow.com/questions/21435339/data-table-vs-dplyr-can-one-do-something-well-the-other-cant-or-does-poorly/27840349#27840349
* Watch the dplyr tutorial on YouTube
http://www.dataschool.io/dplyr-tutorial-for-faster-data-manipulation-in-r/
* do()
http://stat545.com/block023_dplyr-do.html#meet-do
https://www.r-bloggers.com/dplyr-do-some-tips-for-using-and-programming/

---------------------------------------------------------------------------------------
## reshape2
http://seananderson.ca/2013/10/19/reshape.html  

------------------------------------------------------------------------
## Data.table
* R : DATA.TABLE TUTORIAL (WITH 50 EXAMPLES)
http://www.listendata.com/2016/10/r-data-table.html
* Introduction to data.table  
https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html  
* Advanced tips and tricks with data.table  
http://brooksandrew.github.io/simpleblog/articles/advanced-data-table/  
* Data,table cheatsheet  
https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf  

---------------------------------------------------------------------------------------
## Website for R for Data Science Book
http://r4ds.had.co.nz/  

-----
## Caret
- Website for detailed explaination for Caret Package  (very detailed)
http://topepo.github.io/caret/index.html
- Predictive Modeling with R and the caret Package useR! 2013  
http://www.edii.uclm.es/~useR-2013/Tutorials/kuhn/user_caret_2up.pdf
* A Short Introduction to the caret Package Max Kuhn  
https://cran.r-project.org/web/packages/caret/vignettes/caret.pdf  
* Bootcamp Machine Learning Toolbox  
https://www.datacamp.com/courses/machine-learning-toolbox  
* Building Predictive Models in R Using the caret Package  
http://www.jstatsoft.org/v28/i05/paper  

***
## Factor  
https://www.stat.berkeley.edu/classes/s133/factors.html
***
## Regular Expression in R
http://stat545.com/block022_regular-expression.html  
### grep, grepl, regexpr, gregexpr
http://www.regular-expressions.info/rlanguage.html

The regexpr function takes the same arguments as grepl. regexpr returns an integer vector with the same length as the input vector. Each element in the returned vector indicates the character position in each corresponding string element in the input vector at which the (first) regex match was found. A match at the start of the string is indicated with character position 1. If the regex could not find a match in a certain string, its corresponding element in the result vector is -1. The returned vector also has a match.length attribute. This is another integer vector with the number of characters in the (first) regex match in each string, or -1 for strings that didn't match.

gregexpr is the same as regexpr, except that it finds all matches in each string. It returns a vector with the same length as the input vector. Each element is another vector, with one element for each match found in the string indicating the character position at which that match was found. Each vector element in the returned vector also has a match.length attribute with the lengths of all matches. If no matches could be found in a particular string, the element in the returned vector is still a vector, but with just one element -1.

> regexpr("a+", c("abc", "def", "cba a", "aa"), perl=TRUE)  
[1]  1 -1  3  1  
attr(,"match.length")  
[1]  1 -1  1  2  
> gregexpr("a+", c("abc", "def", "cba a", "aa"), perl=TRUE)  
[[1]]  [1] 1   attr(,"match.length")  [1] 1  
[[2]]  [1] -1   attr(,"match.length")  [1] -1  
[[3]]  [1] 3 5  attr(,"match.length")  [1] 1 1  
[[4]]  [1] 1    attr(,"match.length")  [1] 2  
