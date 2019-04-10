---
title: 'Sliding Puzzle Solvable?'
date: 2019-04-10T02:30:00+00:00
author: Andrew B. Collier
tags: ["Python"]
draft: false
---

I'm helping develop a new game concept, which is based on the [sliding puzzle game](https://en.wikipedia.org/wiki/Sliding_puzzle). The idea is to randomise the initial configuration of the puzzle. However, I quickly discovered that half of the resulting configurations were not solvable. Not good! Here are two approaches to getting a solvable puzzle:

- build it (by randomly moving tiles from a known solvable configuration) or
- generate random configurations and check whether solvable.

The first option is obviously more robust. It's also a bit more work. The second option might require a few iterations, but it's easy to implement.

I'm going to embrace my inner sloth and go with the latter.

<img src="/img/2019/04/sliding-puzzle.png" style="max-width: 600px;">

## Puzzle Representation

Rather than representing the puzzle as a matrix it will make sense to us to "unwrap" the puzzle into a vector. So, for example, the final configuration of the puzzle would be

```
[1, 2, 3, 4, 5, 6, 7, 8, 0]
```

where 0 has been used to denote the empty square.

## Inversions and Polarity

To make sense of the algorithm for determining whether a puzzle configuration is solvable we need to define two terms:

- **inversion** &mdash; an inversion is any pair of tiles that are not in the correct order; and
- **polarity** &mdash; is the total number of inversions even (solvable) or odd (not solvable)?

Consider the following puzzle configuration which has six inversions:

```
[1, 3, 4, 7, 0, 2, 5, 8, 6]
```

Let's look at the inversions (since the 0 is just a place holder it's not considered when finding inversions):

- 3 > 2
- 4 > 2
- 7 > 2
- 7 > 5
- 7 > 6 and
- 8 > 6.

Since there are six inversions (even polarity) this configuration is solvable.

Here's a configuration which is not solvable:

```
[2, 1, 3, 4, 5, 6, 7, 8, 0]
```

There's just a single inversion (2 > 1), so the polarity is odd.

<!-- https://math.stackexchange.com/questions/293527/how-to-check-if-a-8-puzzle-is-solvable -->

Some notes on the link between inversions, polarity and solvability can be found [here](https://www.sitepoint.com/randomizing-sliding-puzzle-tiles/).

## Python Implementation

The game concept is being implemented using [Unreal Engine](https://www.unrealengine.com/en-US/), a paradigm with which I am completely unfamiliar. So it made more sense for me to implement the solvability algorithm in Python and just pass this on to the Unreal developer.

So here's the simple function:

{{% render-code file="/content/blog/2019-04-10-sliding-puzzle-solvable.py" language="python" %}}

Let's give it a test run.

{{< comment >}}
print(solvable([1, 2, 3, 4, 5, 6, 7, 8, 0])) #  0 -> solvable
print(solvable([3, 7, 2, 4, 5, 8, 0, 1, 6])) # 12 -> solvable
print(solvable([1, 3, 4, 7, 0, 2, 5, 8, 6])) #  6 -> solvable
print(solvable([1, 8, 2, 0, 4, 3, 7, 6, 5])) # 10 -> solvable
print(solvable([2, 1, 3, 4, 5, 6, 7, 8, 0])) #  1 -> not solvable
print(solvable([8, 1, 2, 0, 4, 3, 7, 6, 5])) # 11 -> not solvable
{{< /comment >}}

```python
>>> solvable([1, 2, 3, 4, 5, 6, 7, 8, 0])
True
>>> solvable([2, 1, 3, 4, 5, 6, 7, 8, 0])
False
```

Looks good. No more broken puzzles!
