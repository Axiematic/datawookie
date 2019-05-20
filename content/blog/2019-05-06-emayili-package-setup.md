---
title: 'emayili: Package Setup'
date: 2019-04-11T03:30:00+00:00
author: Andrew B. Collier
tags: ["R"]
draft: true
---

> library(usethis)
l> library(here)
here() starts at /home/wookie/proj
> PATH = here("demand")
> PATH
[1] "/home/wookie/proj/demand"
> create_package(path)
Error in path_expand(path) : object 'path' not found
> create_package(PATH)
Warning: `recursive` is deprecated, please use `recurse` instead
✔ Creating '/home/wookie/proj/demand/'
✔ Setting active project to '/home/wookie/proj/demand'
Warning: `recursive` is deprecated, please use `recurse` instead
✔ Creating 'R/'
✔ Writing 'DESCRIPTION'
Package: demand
Title: What the Package Does (One Line, Title Case)
Version: 0.0.0.9000
Authors@R (parsed):
    * First Last <first.last@example.com> [aut, cre] (<https://orcid.org/YOUR-ORCID-ID>)
Description: What the package does (one paragraph).
License: What license it uses
Encoding: UTF-8
LazyData: true
✔ Writing 'NAMESPACE'
✔ Changing working directory to '/home/wookie/proj/demand/'
> proj_activate(PATH)
> use_mit_license("Andrew B. Collier")
✔ Setting License field in DESCRIPTION to 'MIT + file LICENSE'
✔ Writing 'LICENSE.md'
✔ Adding '^LICENSE\\.md$' to '.Rbuildignore'
✔ Writing 'LICENSE'
> use_package("prophet", "Imports")
Error: 'prophet' must be installed before you can 
take a dependency on it.
> use_package("prophet", "Imports")
Registered S3 methods overwritten by 'ggplot2':
  method         from 
  [.quosures     rlang
  c.quosures     rlang
  print.quosures rlang
✔ Adding 'prophet' to Imports field in DESCRIPTION
● Refer to functions with `prophet::fun()`
> use_roxygen_md()
Error: Package 'roxygen2' required. Please install before re-trying.
> use_roxygen_md()
✔ Setting Roxygen field in DESCRIPTION to 'list(markdown = TRUE)'
✔ Setting RoxygenNote field in DESCRIPTION to '6.1.1'
● Run `devtools::document()`
> use_roxygen_md()
> use_test()
Error: Package 'testthat' required. Please install before re-trying.
> use_test()
✔ Adding 'testthat' to Suggests field in DESCRIPTION
Warning: `recursive` is deprecated, please use `recurse` instead
✔ Creating 'tests/testthat/'
✔ Writing 'tests/testthat.R'
● Call `use_test()` to initialize a basic test file and open it for editing.
Error: Argument `name` must be specified.
> use_test("tests")
✔ Increasing 'testthat' version to '>= 2.1.0' in DESCRIPTION
✔ Writing 'tests/testthat/test-tests.R'
● Modify 'tests/testthat/test-tests.R'
> use_git()
✔ Initialising Git repo
✔ Adding '.Rhistory', '.RData', '.Rproj.user' to '.gitignore'
