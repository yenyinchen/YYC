

Yen-Yin Chen
5480 Wisconsin Ave Apt 1115,
Chevy Chase, MD 20815
Phone: 850-345-4869
Email: yenyin28@gmail.com
09/26/2018
Highland House

5480 Wisconsin Ave,
Chevy Chase, MD 20815

Dear (Name of landlord or manager),
This letter constitutes my written 60-day notice that I will be moving out of my apartment on 11/30/2018, the end of my current lease.
Please advise me on when my security deposit of $____ will be returned, as well as if you will be taking any money out for damages that fall outside of normal wear and tear.
I can be reached at 850 345 4869 or email at yenyin28@gmail.com after 11/30/2018.
Sincerely,
Yen-Yin Chen

Apt 1115
I would like to schedule a move-out walkthrough in the week prior to my move for an inspection of my apartment. I believe that the apartment is in good condition and my security deposit of $_____ should be refunded in full.
Thank you for your time and consideration on the above matter.
Sincerely,








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
