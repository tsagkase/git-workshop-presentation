# 2. git as a Distributed VCS (PART 2)

## 2.1. Introduction to DVCS (getting more players into the game)

   - if you link the `.git` into a shared folder you have (almost) re-created Subversion
      - better because of optimistic locking
         - focuses on conflicts happening rarely
      - multiple collaborators already supported
         - branches as collaborators
         - concurrent development
      - of course staging would not work (common `index` for all collaborators)
      - would not support asynchronous development
         - development where you are offline for a couple of days and still want version control
   - the **D** in *Distributed Version Control Systems* (*DVCS*) is about empowering more than the *centralized* repository model of working.
   - the *distributed* part refers to *federations* of git repositories
      - imagine **direct** data exchanges (objects / references) among `.git` directories
   - Danaos management focuses on centralized (*GitLab*) repository model of organization but benefits from the distributed version control.

## 2.2. git repos as federations

   - think of git repositories as Star Trek federations
   - the federations communicate with:
      1. `git fetch`, and
      2. `git push`
   - ... ignore `git pull`
      - `git pull` is `git fetch` followed by `git merge`

## 2.3. `git clone`: cloning a repo

   - it's most important file (to mere mortals): `config`
      - config file's structure
      - remotes
      - branch tracking information
   - git clone
   - git remote -v
   - other commands
      - git show-ref

   1. `mkdir clones; cd clones` # open new git bash terminal and go to git_training folder
   2. `git clone /c/Users/{my_username}/git_training/ws1`  # clone repo using a filepath as address
   3. `mv ws1 alice; cd alice`  # rename to avoid confusion
   4. `git remote -v`       # check cloned repository fetch / push addresses
   5. `git log -1`          # check the commit references
   6. `rm .git/hooks/*`     # to focus on important stuff
   7. `tree .git`          # check the remotes
   8. `cat .git/logs/refs/remotes/origin/HEAD`
   9. `date -d @{epoch}`    # confirm that epoch is time of cloning
   10. `cat .git/refs/remotes/origin/HEAD`
   11. `cat .git/config`    # check all the info so far
   12. `cat .git/packed-refs` # check references
   13. `git show-ref master`  # show all references (branches / tags) with master in their name

## 2.4. `git push` to origin

   - git push
   - git push --set-upstream

   14. `cd ..; git clone /c/Users/{my_username}/git_training/ws1 bob; cd bob`  # clone once more
   15. `git checkout -b feature/bob`
   16. `>>foods echo chocolate`
   17. `git add foods`
   18. `git commit --author="Bob <bob>" -m bts`
   19. `git log -2`
   20. `git push`		# note the suggestion
   21. `git push --set-upstream origin feature/bob`
   22. `git log -1`       # notice the references

## 2.5. `git fetch` to origin

   - `git pull` uses `git merge`
      - usually leads to unexpected merges
   - better to fetch and merge at will

   23. `cd ../alice`
   24. `git fetch`     # the blobs and refs for feature/bob are fetched
   25. `git branch`    # only master is here
   26. `git branch -r` # remote branches
   27. `git branch -a` # remote and local branches
   28. `git show-ref master`
   29. `git show-ref bob`
   30. `tree .git/refs`
   31. `git checkout feature/bob`	# looks up local branches and then remote
   32. `tree .git/refs`           # ref to local branch created
   33. `cat .git/refs/remotes/origin/feature/bob`
   34. `cat .git/refs/heads/feature/bob`
   35. `git checkout feature/menu-expansion`  # check the tracking remote branch notice
   36. `>>foods echo pizza`
   37. `git add foods`
   38. `git commit --author='Alice <alice>' -m yummy`
   39. `git log -1`
   40. `git push`
   41. `git log -1`

## 2.6. `git fetch` and `rebase` (instead of `merge`)

   42. `cd ../bob`
   43. `git checkout feature/menu-expansion`  # without fetching
   44. `>>foods echo kebab`
   45. `git add foods`
   46. `git commit --author="Bob <bob>" -m health`
   47. `git log -2`  # you're ahead of origin branch it says
   48. `git fetch`   # now we have the latest from central server
   49. `git log -2`  # you're no longer ahead of origin branch
   50. `git log -2 origin/feature/menu-expansion` # so what now?
   51. `git rebase origin/feature/menu-expansion` # our friend rebase
   52. `git diff`    # pizza or kebab?
   53. `git status`  # note the suggestions
   54. `vim foods`   # resolve conflicts
   55. `git add foods`
   56. `git status`  # the suggestion is to --continue
   57. `git rebase --continue`
   58. `git log -3`
   59. `git push`
   60. `git log -2`

## 2.7 Interactive rebasing: rewriting history

   - Why is it that sometimes you want to rewrite history?
      - you had to do something really weird ***urgently*** that you must take back
      - alternative history communicates intent better
   - `git rebase -i`, the interactive rebase
   - `git rebase --continue`
   - `git log --patch`

   61. `git checkout feature/bob`  # let's do our thing
   62. `>>foods echo concentrated apple`
   63. `git add foods`
   64. `git commit --author="Bob <bob>" -m WIP`
   65. `>>foods echo pork gelatin`
   66. `git add foods`
   67. `git commit --author="Bob <bob>" -m 'hurry! quick!'`
   68. `>>foods echo juice`
   69. `git add foods`
   70. `git commit --author="Bob <bob>" -m "squash onto WIP"`
   71. `git log -4`	# HEAD and HEAD~2 should not be apart
   72. `git rebase -i HEAD~4`  # let's get to work
   73. `vim foods`  # let's fix that conflict
   74. `git add foods`
   75. `git status` # very informative if you care to look
   76. `git rebase --continue`
   77. `git log -1 --patch`
   78. `vim foods`  # more conflicts to resolve
   79. `git add foods`
   80. `git status`
   81. `git rebase --continue`
   82. `git log -1 --patch`
   83. `vim foods`  # even more conflicts to resolve
   84. `git add foods`
   85. `git status`
   86. `git rebase --continue`
   87. `git log -4` # see re-ordered history
   88. `git branch fix/quick HEAD~2`  # to push later
   89. `git rebase HEAD~3`  # let's squash the top two
   90. `git log -2` # yeah

## 2.8 Commit amend

   - `git commit --amend` for last minute changes

   91. `git log -2 --patch`  # oh, noooo
   92. `vim foods`  # let's fix things up
   93. `git diff`   # that's better
   94. `git add foods`
   95. `git commit --amend`  # amend current commit
   96. `git log -2 --patch`  # that's better

## History re-writes are ***NOT*** acceptable in the federation

   - `git rebase -i` and `git commit --amend` both mess with git history
   - you are free to rewrite history to your hearts content ...
      - ... ***ONLY*** on **branches** ***NOT*** **shared** with others.
   - if git history changed on your ***unshared*** branch ...
      - ... you must force push to origin (another *unshared* branch for "backup")

```sh
    git push -f  # who knows not what he does, regrets
```

   - once you merge a branch you own to a shared branch (e.g. `tasks/framework`) ...
      - ... the history rewriting *game is over!*

