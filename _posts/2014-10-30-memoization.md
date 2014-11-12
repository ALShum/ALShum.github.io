---
layout: post
title: "Memoization and Recursion"
description: "Memoization"
author: "alex shum"
modified: 2014-11-11
---


> The following iterative sequence is defined for the set of positive integers:
> 
> n -> n/2 (n is even)
> n -> 3n + 1 (n is odd)
> 
> Using the rule above and starting with 13, we generate the following sequence:
> 
> 13 -> 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1
> It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
> 
> Which starting number, under one million, produces the longest chain?
> 
> NOTE: Once the chain starts the terms are allowed to go above one million.

{% highlight julia %}
#iterative
function iterative_solver(n)
  K = zeros(Int, n) #memoization

  for i = 2:n
    l = 0
    n = i
    while(n >= i)
      l = l + 1
      n = n % 2 == 0 ? n/2 : 3*n + 1
    end
    K[i] = K[n] + l
  end
  return(K)
end

tic()
indmax(iterative_solver(1000000))
toc()
{% endhighlight %}

{% highlight julia %}
#recursion
L = Dict{Int, Int}()
function recursive_solver(n, l) 
  if(n == 1) 
    return(l)
  elseif(haskey(L, n))
    return(l + L[n] - 1)
  else
    prev = n
    l = l + 1
    n = n % 2 == 0 ? n/2 : 3*n + 1
    
    toReturn = recursive_solver(n, l)
    L[prev] = toReturn - l + 2;
    return(toReturn)
  end
end

function longest_collatz_num(n)
  max = -1
  max_num = -1
  ans = 0
  for i=1:n
    ans = recursive_solver(i, 1)
    if(ans > max)
      max = ans;
      max_num = i;
    end
  end
  return(max_num)
end
    
#recursive_solver(3,1)
tic()
longest_collatz_num(1000000)
toc()
{% endhighlight %}
