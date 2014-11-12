---
layout: post
title: "Solving problems with data structures in Julia"
description: "Maps in Julia and R"
modified: "2014-11-11"
---


A lot of programming problems can be solved simply using the correct datastructures.  In the process of learning Julia we review some data structures in Julia to solve some problems.  The following is a solution to project euler [problem 17](https://projecteuler.net/problem=17).

> If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
> 
> If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?
> 
> 
> NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when writing out numbers is in compliance with British usage.

{% highlight julia %}
#euler 17
num2string = [1 => "one", 2 => "two", 3 => "three",
              4 => "four", 5 => "five", 6 => "six",
              7 => "seven", 8 => "eight", 9 => "nine",
              10 => "ten", 11 => "eleven", 12 => "twelve",
              13 => "thirteen", 14 => "fourteen", 15 => "fifteen",
              16 => "sixteen", 17 => "seventeen", 18 => "eighteen",
              19 => "nineteen", 20 => "twenty", 30 => "thirty",
              40 => "forty", 50 => "fifty", 60 => "sixty", 
              70 => "seventy", 80 => "eighty", 90 => "ninety", 
              1000 => "onethousand"]

function ending(num, num2string) 
  num_string = string(num)
  if(haskey(num2string, num))
    return(num2string[num])
  end
  
  first = num2string[parseint(num_string[1]) * 10]
  second = num2string[parseint(num_string[2])]
  return(string(first, "", second))
end

function beginning(num, num2string)
  num_string = string(num) 
  hundreds_string = num2string[parseint(num_string[1])]
  tens = parseint(num_string[2:3])
  tens_string = tens != 0 ? string("hundredand", ending(tens, num2string)) : "hundred"
  return(string(hundreds_string, tens_string))
end

function toString(num, num2string)
  if(haskey(num2string, num)) 
    return(num2string[num])
    
  else
    num_string = string(num)
    if(length(num_string) == 2)
      return(ending(num, num2string))
      
    elseif(length(num_string) == 3)
      return(beginning(num, num2string))
      
    else
      throw(ArgumentError("Invalid input: number not in range [1, 1000]"))
    end
  end
end

#run above functions
sum = 0
for i = 1:1000
  sum += length(toString(i, num2string))
end
print(sum)
{% endhighlight %}

All we do here is have a dictionary to map the numbers to their english equivalent.  After defining the a few base numbers in the dictionary we can build strings for every other number.  The spaces are removed from the words simply because the problem description says not to count the spaces.  

The standard data structures available in Julia are quite nice.  This example is a problem that can be solved quite easily with a map.  This example was chosen because coming from R there is no equivalent data structure.  The closest data structures are environments and lists in R.  However, for a lot of uses environments and lists don't quite act in the same way as a dictionary or map.

{% highlight r %}
num2string = list()
num2string[1] = "one"
num2string[5] = "five"
print(num2string)
{% endhighlight %}



{% highlight text %}
## [[1]]
## [1] "one"
## 
## [[2]]
## NULL
## 
## [[3]]
## NULL
## 
## [[4]]
## NULL
## 
## [[5]]
## [1] "five"
{% endhighlight %}
Using a list to build a map from integers to strings it looks like it unnecessarily fills in all the values inbetween 1 and 5 with NAs.  So if I have gaps in the domain of my map the list will automatically fill them in.

I could try to do the same thing with environments:

{% highlight r %}
num2string = new.env()
num2string$`1` = "one"
num2string$`5` = "five"
{% endhighlight %}
The problem with environments is that you cannot index with integers.  To map integers to strings the best you can do is cast integers to strings and map strings to strings.
