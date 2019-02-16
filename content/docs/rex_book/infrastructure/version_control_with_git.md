---
title: Version Control with Git
---

We recommend you to use a version control system for your development. Especially if you're working in a team it will bring you many advantages. Also if you want to see the difference between two versions of the same file you can ask your vcs system.

A working vcs is also the base to work in teams. So every teammate can be sure that he/she has the latest available version of the files.
Advantages if you use a VCS

-   You can revert changes
-   You have a history of changes
-   You can easily work together with teammates
-   You can experiment with new features using an own branch that doesn't affect production.

## Creating a git repository

Creating a git repository is easy

    $ git init-db
    $ git add Rexfile
    $ git add lib
    $ git commit -m "inital commit"

Now you also can connect this to your GitHub account and push your changes to it.

    $ git push origin master

## The workflow

Now as you setup your repository you can use the following workflow to update your local repository and to upload your changes to GitHub.

Get the latest things from GitHub

    $ git pull

If you have changed things and want to add them to the repository you have to follow these steps:

    $ git add Rexfile
    $ git commit -m "Changed this and that"
    $ git push

 

 
