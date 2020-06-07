---
title: LeetCode Challenge - June 5, 2020
date: 2020-06-06 19:30:00 +01:00
description: Explaining LeetCode Solutions.
categories: LeetCode-Challenge
tags: code, python
---
## Random Pick with Weight - From LeetCode
Source: LeetCode, [https://leetcode.com/explore/featured/card/june-leetcoding-challenge/539/week-1-june-1st-june-7th/3351/]()  

Given an array w of positive integers, where w[i] describes the weight of index i, write a function pickIndex which randomly picks an index in proportion to its weight.

Note:
* `1 <= w.length <= 10000`
* `1 <= w[i] <= 10^5`
* `pickIndex will be called at most 10000 times.`

### Example 1:

**Input:**

```python
["Solution","pickIndex"]
[[[1]],[]]
```

**Output:**

```python
[null,0]
```


### Example 2:

**Input:**

    ["Solution","pickIndex","pickIndex","pickIndex","pickIndex","pickIndex"]
    [[[1,3]],[],[],[],[],[]]

**Output:**

    [null,0,1,1,1,0]

#### Explanation of Input Syntax:

The input is two lists: the subroutines called and their arguments. Solution's constructor has one argument, the array w. pickIndex has no arguments. Arguments are always wrapped with a list, even if there aren't any.

-----
## My Explanation
### Explanation of what the problem actually states:
1. A list `w` will be passed with different values in there.

2. The method `pickIndex()` is supposed to return a random index of this list.
   I.e. the return value will be within of `range(len(w))`

3. Here is the catch: **The values in the list are weights for the probability!**
   If the value at an index is higher, it should be returned with higher probability.


### Example 1 - Coinflip:
A coinflip can be simulated with the input list `w = [1, 1]`.
Notice how both values in the list have the values? That means pickIndex should return `0` with the same probability as `1`.

The coinflip example can also be simulated with any other list that contains
* Two entries.
* Both entries with the same values.

E.g. `w = [7, 7]`.


### Example 2 - Betting on Color in Roulette:
Roulette is a gambling game in which the outcome is decided by the landing spot of a ball in a spinning table.
The ball can land in one of 37 fields. Eighteen of which are red, eighteen are black and one is of no color.

Players can bet on the color. E.g: "I believe the ball will land in a black field!". There is a chance of 18/37 that the player will win that bet.

To simulate the colors of a roulette game, we can define the colors to correspond to numbers
* Zero  -> 0
* Red   -> 1
* Black -> 3

The probabilities are set as:

```python
         Zero    Red  Black
w  =  [     1,    18,    18 ]
```


Then `pickIndex()` will return the number corresponding to the color.


## Walkthrough of Solution

### Premises
* All solutions are based on the `randint(a, b)` function of Python. **Why?:** This function returns any integer between a..b with *equal probability*. Almost every programming language has such a function built-in. This allows **portability of the solution**. (Disclaimer, I use randint instead of randrange because it is closer to random functions in other languages.)
* The cumulative sum of all weights in `w` is <= 10^9 < 2^30. This fits into a single UInt32!

### Possible Ways to Simulate Weighted Probability
Getting a random index of an equal-weighted list is easy: `i = randint(0, len(w) -1)`.

One inspiration to introduce the weights into the algorithm are raffle tickets. Every raffle ticket has the same probability to be drawn (compare to `randint()`). However, people can buy multiple raffle tickets to increase their chance of winning.

With this analogy, we have the following mapping:
* ID of Person holding raffle ticket                -> Index i
* Number of raffle tickets one single person holds  -> Weight `w[i]`
* Total number of raffle tickets                    -> w[0] + w[1] + .. + w[N]


### Solution 1 (Unoptimzed. Closest to analogy)
Introduce a list `pot` to hold all "raffle tickets". Each "raffle ticket" should carry the ID of the owner.

If `w = [1, 3, 3, 7]`, and if `pot` was ordered, then
```python
pot = [0,  1, 1, 1,  2, 2, 2,  3, 3, 3, 3, 3, 3, 3]
```

In this case the weighted random choice will simply be a single draw out of the pot of raffle tickets.

```python
return pot[ randint(0, len(pot)-1) ]
```

**Tradeoffs**
A very severe drawback of this solution is memory consumption. The pot will need to hold up to 10^9 integer entries. If the indices were all UInt32 (4 Byte), the total memory consumption of pot will be 4e9 Byte = 4 GB !!!

### Solution 2 (Optimized for memory)
This solution will use the cumulative sum of `w`, which will be <= 2^30 and thus fit into one single UInt32.

Again, imagine the pot from the first solution. The raffle ticket that is drawn can be described with the index.
If the pot was ordered, the IDs of the ticket owners will occupy following ranges:

```python
w = [1, 3, 3, 7]

pot = [0,  1, 1, 1,  2, 2, 2,  3, 3, 3, 3, 3, 3, 3]

#     [0] Range of indices occupied by tickets of person 0
#          [1 .. 3] Range of indices occupied by tickets of person 1
#                    [4 .. 6] Range of indices occupied by tickets of person 2
#                              [7 ............. 13] Range of indices occupied by tickets of person 3
```

This means that the task to return a random index from the weights can be split up into (1) storing a mapping of index to ranges, (2) a draw from the sum of all weights with equal probability, (3) returning the index mapped to the drawn number.

```python
i = drawFromPot()

if i == 0:
    print('Person 0 won!')
    return 0

elif 1 <= x <= 3:
    print('Person 1 won!')
    return 1

elif 4 <= x <= 6:
    print('Person 2 won!')
    return 2

elif 7 <= x <= 13:
    print('Person 3 won!')
    return 3
```

**Tradeoffs**
This solution (which is implemented below) will take up far less memory than Solution 1.
However it will consume more runtime! While the lookup of the index in Solution 1 will be a single indexed retrieval of an element from a list, Solution 2 will need to perform a search every time `pickIndex()` is called.

## Summary
Two solutions were presented in concept. When runtime is the constraint, choose Solution 1. When memory is the constraint, choose Solution 2.

This problem perfectly shows an often encountered tradeoff: Memory vs. Consumption.



# Solution Source Code

```python
import random

class Solution:

    def __init__(self, w: List[int]):
        self.pot_marker = []
        # pot_marker[i] shall hold the first index in a hypothetical list `pot` that does **not** belong to person i anymore.
        # Using the example above (w = [1, 3, 3, 7]), pot_marker would be [1, 4, 7, 14].

        for id in range(len(w)):
            if id == 0:
                self.pot_marker.append(w[0])
            else:
                # If it is not the first element of w, add all the previous values to pot_marker[id].
                self.pot_marker.append(self.pot_marker[id-1] + w[id])

        self.n_raffletickets = self.pot_marker[-1] # The last value of pot_marker holds the total number of raffle tickets - 1


    def pickIndex(self) -> int:
        # Draw the raffle ticket.
        drawn_raffleticket = random.randint(0, self.n_raffletickets - 1)

        for i in range(len(self.pot_marker)):
            if self.pot_marker[i] > drawn_raffleticket:
                return i

        # Instead of this for-loop, you can also use the bisect function:
        #     return bisect.bisect(self.pot_marker, drawn_raffleticket)
        #
        # This will run much faster, as bisect has been optimized for this specific case of looking up the place of a value in a sorted list.



# Your Solution object will be instantiated and called as such:
# obj = Solution(w)
# param_1 = obj.pickIndex()
```

&#x1F3B2;
