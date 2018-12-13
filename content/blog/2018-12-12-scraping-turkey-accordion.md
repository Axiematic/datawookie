---
author: Andrew B. Collier
date: 2018-12-12T02:00:00Z
tags: ['R', 'web-scraping']
title: Scraping the Turkey Accordion
---

{{< comment >}}
https://www.woolworths.co.za/prod/Christmas/Festive-Foods/Meat-Poultry-Fish/Turkey-Gammon/Frozen-Turkey-Avg-5Kg/_/A-2083530000007
{{< /comment >}}

<img src="/img/2018/12/turkey-accordion.jpg" width="100%">

One of the things I like most about web scraping is that almost every site comes with a new set of challenges.

## The Accordion Concept

I recently had to scrape a few product pages from the site of a large retailer. I discovered that these pages use an "accordion" to present the product attributes. Only a single panel of the accordion is visible at any one time. So, for example, you toggle the _Details_ panel open to see the associated content.

![](/img/2018/12/turkey-accordion-details.png)

To see the _Ingredients_ panel, you toggle that one open. However, when it opens, the _Details_ panel immediately closes. So there is only ever one panel open at a time.

![](/img/2018/12/turkey-accordion-ingredients.png)

A bit of research reveals that there are a few ways to implement an accordion, all of which rely on CSS or JavaScript (or, most commonly, a combination of the two).

## The Accordion Implementation

Those that are implemented in CSS alone are a relatively easy target for scraping because the content of all of the panels is always accessible on the page.

Bringing JavaScript into the mix can make things appreciably more complicated: when the content of a panel is not visible, it's probably not even present in the page source. This, of course, means that it's inaccessible to a scraper (if it's not in the page then you cannot scrape it!). You can see this effect clearly in the HTML code (below). The active panel (framed in red) has content in the inner `div`. The inactive panels all have class `is-collapsed` and for each of them the inner `div` is empty.

![](/img/2018/12/turkey-accordion-elements.png)

## Scraping the Accordion

I wanted to scrape the content of each of the accordion panels. Since the entire accordion is rendered in JavaScript, static scraping tools are hopeless. Thankfully there are alternatives like [Splash](https://github.com/scrapinghub/splash) and [Selenium](https://www.seleniumhq.org/). I used the latter via the `RSelenium` package.

Once you've figured out how the accordion is built, the scraping is relatively simple.

1. Fire up a [Selenium Docker](https://hub.docker.com/u/selenium/) container. I'm using `selenium/standalone-chrome-debug:3.11`.

2. Create a `remoteDriver` instance (mine is called `browser`) and run the `open()` method.

3. Use the `navigate()` method to open the web page.

4. Locate the elements on the page which contain the accordion panels.

	{{< highlight r >}}
# Select the accordion panels.
accordion <- browser$findElements(using = 'css selector', '.accordion > .accordion__segment')
{{< /highlight >}}

5. Loop through each of these elements, expanding the corresponding panel and scraping the required content.

{{< highlight r >}}
lapply(accordion, function(panel) {
  # Locate the toggle.
  toggle <- panel$findChildElement(using = 'css selector', '.accordion__toggle')
  # Expand section (toggle if it is currently collapsed).
  if (str_detect(toggle$getElementAttribute("class")[[1]], "is-collapsed")) toggle$clickElement()
  
  # Extract content from the panel!
})
{{< /highlight >}}

It makes sense to wrap the final three steps up in a function so that they can be applied systematically to one or more pages. I'm returning a `tibble` for each panel and then using `bind_rows()` to concatenate them all into a single `tibble`.