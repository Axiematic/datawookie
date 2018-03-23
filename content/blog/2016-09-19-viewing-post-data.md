---
id: 4272
title: View POST Data using Chrome Developer Tools
date: 2016-09-19T15:00:38+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=4272
categories:
  - Web Scraping
tags:
  - Chrome
  - Developer Tools
  - POST
  - Web Scraping
---
When figuring out how to formulate the contents of a POST request it's often useful to see the "typical" fields submitted directly from a web form.

1. Open [Developer Tools](https://developer.chrome.com/devtools) in Chrome. Select the `Network` tab (at the top). 
2. Submit the form. Watch the magic happening in the Developer Tools console. <img src="{{ site.baseurl }}/static/img/2016/09/Developer-Tools-Network-1.png">
3. Click on the first document listed in the Developer Tools console, then select the `Headers` tab. <img src="{{ site.baseurl }}/static/img/2016/09/Developer-Tools-Network-2.png">

That's just scratching the surface of the wealth of information available on the `Network` tab. Read [this](https://developers.google.com/web/tools/chrome-devtools/profile/network-performance/resource-loading) to find out more.
