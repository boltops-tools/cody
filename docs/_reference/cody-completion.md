---
title: cody completion
reference: true
---

## Usage

    cody completion *PARAMS

## Description

Prints words for auto-completion.

Example:

    cody completion

Prints words for TAB auto-completion.

Examples:

    cody completion
    cody completion hello
    cody completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(cody completion_script)

Auto-completion example usage:

    cody [TAB]
    cody hello [TAB]
    cody hello name [TAB]
    cody hello name --[TAB]


## Options

```
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

