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

## Fuzzy String Matching – a survival skill to tackle unstructured information
https://www.r-bloggers.com/fuzzy-string-matching-a-survival-skill-to-tackle-unstructured-information/

## Package ‘stringr’
