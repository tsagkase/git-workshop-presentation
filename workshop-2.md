# `git`: a ***Distributed*** VCS

## 1. Introduction to DVCS

### 1.1 Getting collaborators in the game

   - turn `.git` into a shared folder to get Subversion :-p
      - better because of optimistic locking
         - focus on conflicts happening rarely
      - multiple collaborators already supported
         - branches as collaborators
         - concurrent development

### 1.2 Nice try but nuh!

   - *staging* would not work (common `index` file for all)
   - would not support ***asynchronous*** development
      - we are offline for a couple of days, and
      - we still want version control!

### 1.3 *Distributed* means something else

   - the **D** in *DVCS* is something else
      - it empowers more than the *centralized* repository model
   - think of a ***federation*** of *distributed* `git` repositories
      - imagine **direct** data exchanges (objects / references) among `.git` directories
   - our setup may focus on *centralized* (*GitLab*) repository model of organization ...
   - ... but benefits of distributed version control are there for all!

### 1.4 `git` repos as parts of *federation*

   - think of git repositories as autonomous provinces of a federation
   - the federation provinces communicate with:
      1. `git fetch`, and
      2. `git push`
   - ... ignore `git pull`
      - `git pull` is:

```sh
    git fetch
    git merge
```

## 2. Creating the repos federation

### 2.1 `git clone`: joining the repos federation

   - the default way to join a repo federation is `git clone`
   - default *remote* repo name is `origin`
   - `git clone` means ...
      - copy `origin`'s `.git` directory
      - rename *references* as pointing to `origin` objects

   - prefer `git://` to `https://` when cloning
      - ***professionals use strong password ssh keys***


### 2.2 Let's start cloning

   1. open new `git-bash` terminal and go to `git_training` folder

```sh
    mkdir clones; cd clones
```

   2. clone repo using a filepath as address ... yes, you can do it

```sh
    git clone /c/Users/{usr}/git_training/the_repo
```

   3. rename repo to avoid confusion

```sh
    mv the_repo alice; cd alice
```

   4. check cloned repository fetch / push addresses

```sh
    git remote -v
```

   5. check the commit references

```sh
    git log -1
```

### 2.3 `git clone`: internals (part 1)

   6. to focus on important stuff

```sh
    rm .git/hooks/*
```

   7. check the remotes

```sh
    tree .git
```

   8. check the `HEAD` of the remote branch

```sh
    cat .git/logs/refs/remotes/origin/HEAD
```

   9. confirm that epoch is time of cloning

```sh
    date -d @{epoch}
```

### 2.3 `git clone`: internals (part 2)

   10. check the `HEAD` of the remote branch

```sh
    cat .git/refs/remotes/origin/HEAD
```

   11. `.git/config` file contains all you need 99% of time

```sh
    cat .git/config
```

   12. check (packed) references

```sh
    cat .git/packed-refs
```

   13. show all references (branches, tags, etc) with `master` in their name

```sh
    git show-ref master
```

### 2.4 `git clone`: an appreciation

   - it's the fastest way to get started
   - most important file (to mere mortals): `.git/config`
      - human-readable
      - contains *remotes* information
      - contains branch tracking information

   - helpful commands
      - `git remote -v`
      - `git show-ref`


## 3. Pushing work to the federation


### 3.1 Join the federation (more clones)

   14. Bob clones

```sh
    cd ..
    REPO=/c/Users/{usr}/git_training/the_repo
    git clone $REPO bob
    cd bob
```

   15. Bob is ready to work

```sh
    git checkout -b feature/bob
```

   16. Bob has a sweet tooth

```sh
    >>foods echo chocolate
```

   17. staging the work

```sh
    git add foods
```

   18. commit

```sh
    git commit --author="Bob <bob>" -m bts
```

### 3.2 `git push` to `origin`

   - `git push`
   - `git push --set-upstream`

   19. check progress so far

```sh
    git log -2
```

   20. note the suggestion

```sh
    git push
```

   21. push work to `origin` (the federation's central repo)

```sh
    git push --set-upstream origin feature/bob
```

   22. notice the references

```sh
    git log -1
```

## 4. Fetching federation updates

### 4.1 `git fetch`: retrieve from remote repo

   - `git pull` uses `git merge`
      - often leads to unexpected merges
   - better to `fetch` and `merge` *at will*


### 4.2 Alice gets the updates

   23. meanwhile Alice ...

```sh
    cd ../alice
```

   24. the blobs and refs for feature/bob are fetched

```sh
    git fetch
```

   25. only `master` is here

```sh
    git branch
```

   26. what about remote branches?

```sh
    git branch -r
```

   27. remote *and* local branches?

```sh
    git branch -a
```

### 4.3 `git fetch` internals

   28. show all `master`s

```sh
    git show-ref master
```

   29. show all `bob`s

```sh
    git show-ref bob
```

   30. check the references also

```sh
    tree .git/refs
```

### 4.4 `checkout` fetched branch

   31. looks up local branches and then remote

```sh
    git checkout feature/bob
```

   32. ref to local branch created

```sh
    tree .git/refs
```

   33. check the remote branch's `HEAD` commit

```sh
    cat .git/refs/remotes/origin/feature/bob
```

   34. check the local branch's `HEAD` commit

```sh
    cat .git/refs/heads/feature/bob
```

### 4.5 Get to work!

   35. check the tracking remote branch notice

```sh
    git checkout feature/menu-expansion
```

   36. augment the menu

```sh
    >>foods echo pizza
```

   37. stage and ...

```sh
    git add foods
```

### 4.6 Federated `git` references

   38. ... commit!

```sh
    git commit --author='Alice <alice>' -m yummy
```

   39. check the commit's log

```sh
    git log -1
```

   40. push to `origin`

```sh
    git push
```

   41. check the commit's annotated log again

```sh
    git log -1
```

## 5. `git fetch` and `rebase` (instead of `merge`)

### 5.1 Bob works on same branch


   42. Back to Bob

```sh
    cd ../bob
```

   43. without `fetch`ing

```sh
    git checkout feature/menu-expansion
```

   44. dome more deli

```sh
    >>foods echo kebab
```

   45. staging

```sh
    git add foods
```

   46. commit (Bob isn't aware of Alice's work here)

```sh
    git commit --author="Bob <bob>" -m health
```

### 5.2 Bob finds out Alice was faster

   47. Bob is ahead of `origin` branch ... it says

```sh
    git log -2
```

   48. let's get the latest from `origin`

```sh
    git fetch
```

   49. Bob is no longer ahead of `origin` branch

```sh
    git log -2
```

   50. where is `origin` branch at?

```sh
    git log -2 origin/feature/menu-expansion
```

### 5.3 `rebase` to the rescue

   51. `rebase` to the rescue ... note **`origin/`** reference

```sh
    git rebase origin/feature/menu-expansion
```

   52. pizza or kebab?

```sh
    git diff
```

   53. notice the instructions

```sh
    git status
```

   54. resolve conflicts

```sh
    vim foods
```

### 5.4 Conflict resolved

   55. stage resolution

```sh
    git add foods
```

   56. the instruction is to `--continue`

```sh
    git status
```

   57. continue with the `rebase`

```sh
    git rebase --continue
```

   58. check the log

```sh
    git log -3
```

   59. `push` the work to `origin`

```sh
    git push
```

   60. check the log annotations now

```sh
    git log -2
```

## 6. Re-writing history

### 6.1 But why re-write history?

   - break commit down to smaller commits to merge elsewhere
   - weird commits made in a hurry that shouldn't be pushed
   - clean history communicates intent better
   - sometimes local setup "demands" it

### 6.2 How to re-write history?

   - the interactive rebase: `git rebase -i`
   - you can interactively:
      - remove commits
      - re-order commits
      - squash commits
      - re-edit commits

### 6.3 Bob commits WIP

   61. Bob is ready to rock 'n' roll

```sh
    git checkout feature/bob
```

   62. while working he's asked to switch to something else

```sh
    >>foods echo concentrated apple  # no juice
```

   63. stage WIP

```sh
    git add foods
```

   64. commit WIP

```sh
    git commit --author="Bob <bob>" -m WIP
```

### 6.4 Bob works on urgent commit

   65. working on emergency (should have switched branch but ok)

```sh
    >>foods echo pork gelatin
```

   66. stage the urgent work

```sh
    git add foods
```

   67. commit requested work

```sh
    git commit --author="Bob <bob>" -m 'urgent!'
```

### 6.5 Bob continues WIP

   68. back to WIP (customer is "out to lunch")

```sh
    >>foods echo juice
```

   69. stage completion of WIP

```sh
    git add foods
```

   70. commit completion of WIP

```sh
    git commit --author="Bob <bob>" -m 'squash with WIP'
```

   71. `HEAD` and `HEAD~2` should not be apart

```sh
    git log -4
```

### 6.6 Bob groups commits (conflict)

   72. rewrite recent 4 commits' history

```sh
    git rebase -i HEAD~4  # group commits
```

   73. let's fix that conflict

```sh
    vim foods
```

   74. stage conflicts resolution

```sh
    git add foods
```

   75. very informative if you care to look

```sh
    git status
```

   76. continue the `rebase`

```sh
    git rebase --continue
```

### 6.6 Bob groups commits (more conflict)

   77. check committed changes

```sh
    git log -1 --patch
```

   78. more conflicts to resolve

```sh
    vim foods
```

   79. stage conflicts resolution

```sh
    git add foods
```

   80. check status

```sh
    git status
```

   81. continue the `rebase`

```sh
    git rebase --continue
```

   82. check committed changes

```sh
    git log -1 --patch
```

### 6.6 Bob groups commits (even more conflict)

   83. even more conflicts to resolve

```sh
    vim foods
```

   84. stage conflict resolution

```sh
    git add foods
```

   85. check status

```sh
    git status
```

   86. continue the `rebase`

```sh
    git rebase --continue
```

### 6.7 Bob squashes WIP commits

   87. see re-ordered history

```sh
    git log -4
```

   88. create urgent branch (push later)

```sh
    git branch fix/urgent HEAD~2
```

   89. squash top two WIP commits

```sh
    git rebase HEAD~3
```

   90. yeah

```sh
    git log -2
```

### 6.8 Last minute changes: `git commit --amend`

   91. oh, noooo

```sh
    git log -2 --patch
```

   92. let's fix things up

```sh
    vim foods
```

   93. that's better

```sh
    git diff
```

   94. stage work

```sh
    git add foods
```

   95. amend current commit

```sh
    git commit --amend
```

   96. looks good

```sh
    git log -2 --patch
```

### 6.9 History re-writes and the federation

   - ***DON'T*** **`push` re-written history**

   - the following mess up `git` branch history:
      - `git rebase -i`
      - `git commit --amend`
   - you can rewrite history ***ONLY*** on **branches** ***NOT*** **shared**
   - if `git` history changed on ***un-shared*** branch (e.g. `push`ed for *backup*)
      - then you must **force** `push`

```sh
    git push -f # only for un-shared branches
```

   - once you merge a branch with a *shared* branch (e.g. `tasks/framework`)
      - the history rewriting **game is** ***over***!

## 7. Conclusion

### 7.1 Recap

   - `git` works well in a federation of repositories
   - `git` commands for this:
      - `git clone`
      - `git fetch`
      - `git push`
      - `git remote`
   - `git` storage model does not change
      - just *references* indicate remote repositories

### 7.2 Clean, legible commit history is nice

   - sometimes you may have to re-write `git` commits history
   - pushing re-written history leads to 

\tiny
```
     ! [rejected]   a_branch -> a_branch (non-fast-forward)
    error: failed to push some refs to '.../cool-project.git'
    hint: Updates were rejected because the tip of your current branch is behind
    hint: its remote counterpart. Integrate the remote changes (e.g.
    hint: 'git pull ...') before pushing again.
    hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
\normalsize

   - think twice before you *force* `push`
      - is this branch shared?

