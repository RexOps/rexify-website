---
title: Tab completion with bash
---

## How tab completion works with the rex command

Tab completion allows you to quickly type in task names, group names, file
names, host names, and environments from the command line. You simply type in
the first few letters of the name, hit the <TAB> key and bash will do it's
best to finish typing in the rest of the name for you, or as much as it can
until you type in another letter or two and hit <TAB> again.

Tab completion will kick in whenever you type in the `rex` command at the
command line and hit the <TAB> key. bash will look for a Rexfile or rex yaml
file in the. It will intelligently determine where in the rex command you are
to help guess at what you want to type. For example, if you just typed in the
`-G` option, type in a couple of letter and hit <TAB>, rex's bash completion
script will provide bash with list of possible groups based on the letters you
typed.

## Setting up tab completion

Follow these steps to get rex's tab completion feature working on your
command line:

1. Download or copy and paste the [Rex tab completion script](https://github.com/RexOps/Rex/blob/master/misc/rex-tab-completion.bash)
2. Place the script into your desired location, usually in your home directory.
3. Source the script with by running `source rex-tab-completion.bash` on the
   command line.
4. If desired, add the command in step 3 to your `.bashrc` file so it will be
   available every time you log into your shell.
