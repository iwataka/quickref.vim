# quickref.vim

## Motivation

When you write programs, you may want to view source codes of libraries,
applications or something like that which you use. If you use this plug-in, you
can view them without any effort!

## Introduction

This plug-in provides quick access to any references in your local environment.
Concretely, this can do these tasks:

+ Detects the current project root and add it to its own cache automatically.
+ Provides commands which adds specified paths to the cache and removes them
  from it.
+ Enable to select one of the paths quickly and executes an arbitrary task at
  it.

The third one uses the existing plug-ins which are so-called narrowing
frameworks (currently only [CtrlP](https://github.com/ctrlpvim/ctrlp.vim), but
planning to support [Unite](https://github.com/Shougo/unite.vim)).

## Usage

You can get a buffer which contains some project roots you have accessed to
and some directories you have registered by running `:Quickref` command. You can
narrow the selections by typing characters, choose one of them and executes
specified task to it.

You have two ways to register arbitrary paths to the cache. First one is assigns
them to `g:quickref_paths` variable like this:

```vim
let g:quickref_paths = [
    \ '~/A/B'
    " Wildcars are automatically expanded.
    \ '/C/*',
    " You want to exclude specified path, put '!' at the head.
    \ '! /C/D/'
]
```

Second one is running `:QuickrefAdd` and `:QuickrefRemove` command like this:

```vim
" Registers the current working directory.
:QuickrefAdd
" Registers specified path.
:QuickrefAdd ~/A/B
" Registers specified path which contains wildcars.
:QuickrefAdd /C/*
" Removes specified path .
:QuickrefRemove /C/D/
" You can register several different paths at the same time.
:QuickrefAdd ~/A/B /C/*
```

## CtrlP

If you want to know the outline of using `CtrlP` interface, see its help. When
running `:Quickref` command, you get `CtrlP` interface containing the registered
paths and can select one of them by typing characters. You have four keys to
execute specified task to it:

+ `<Enter>` to get `CtrlP` interface again in the selected path and select one
  or more of the files in it.
+ `<C-t>` to move the current directory to the selected one.
+ `<C-v>` to do the same thing as `<C-t>`
+ `<C-x>` to get the file-explorer in the selected path.

## Requirement

+ [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

+ xdg-open (if you use Linux OS)

## Installation

You can use your favorite package manager to install this. If you don't have
your own package manager for Vim, I recommend
[vim-plug](https://github.com/junegunn/vim-plug) to you!
