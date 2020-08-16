---
title: cody list
reference: true
---

## Usage

    cody list

## Description

list codebuild project.


## Options

```
[--format=FORMAT]            # Output formats: csv, table, tab, json
[--sort-by=SORT_BY]          # Sort by column: name, status, time
[--status=STATUS]            # status filter. IE: SUCCEEDED, FAILED, FAULT, TIMED_OUT, IN_PROGRESS, STOPPED. Both upper and lowercase works.
[--select=SELECT]            # select filter on the project name. The select option gets converted to an Ruby regexp
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

