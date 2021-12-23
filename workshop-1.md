# Git: a Version Control System (VCS)

## 1. VCS history

   - SCCS(1972)
   - RCS (1982) - interleaved deltas
   - CVS(1986) - RCS front-end, delta compression
      - I started with it in 1994
   - Subversion(2000) - was the first sexy (*non distributed*) VCS
      - switched to it from CVS in 2001
   - ***pessimistic locking*** (focusing on conflict avoidance instead of conflict resolution)
      - was prevalent
      - was a bad idea

## 2. git as VCS

### 2.1 git as VCS (intro)

   - works beautifully as a VCS
      - works nicely for one dev only
      - works for any size of project

   - `git` tracks:
      - ***data***, and
      - a ***DAG*** (graph)

   - `git` does **NOT** (not really) track filesystem constructs (i.e. file directory names)
      - `git mv` (i.e. *move / rename*) is a hack!

   - `git` is *case sensitive*
      - file / directory names (even branch names) lead to issues in interplay between case in/sensitive FSes

### 2.2 git as VCS (fundamentals)

   - `git` fundamentals are:
      1. Objects:
         1. ***blobs***
         2. ***trees***
         3. ***commits***
      2. Naming system for the objects:
         1. ***references***
   - For more details:
      - [A Visual Guide to Git Internals](https://www.freecodecamp.org/news/git-internals-objects-branches-create-repo/)

## 3. Work session explained

### 3.1 The premise

   - from ***no repository*** ...
   - ... to ***branches***, ***rebasing*** and ***merging***.

   - at the same time explore `git` internals (*objects* and *references*)

   - *local* `git`, with no remote (push / fetch)

   - command-line only (Rambo mode)
      - `git-bash`

### 3.2 Session preparation

```sh
    EDITOR="/c/Windows/System32/notepad.exe"
    git config --global core.editor $EDITOR
    alias tree=tree.com
```

## 4. Repository creation

### 4.1 `git init`

   1. an empty directory

```sh
    ls -la
```

   2. not a `git` repo yet (fails)

```sh
    git status
```

   3. create git repo

```sh
    git init
```

   4. git init created `.git/` and it's contents

```sh
    ls -la
```

   5. git is alive

```sh
    git status
```

### 4.2 New repository explored

   6. check `.git` folder structure

```sh
    tree .git
```

   7. remove unnecessary noise to focus

```sh
    rm .git/hooks/*
```

   8. this is `git`'s database

```sh
   tree .git
```

   9. no commits yet (fails)

```sh
    git log
```

## 5. *Staging*: objects without *reference*

### 5.1 The *workdir*

   - `git status`

   10. create some content

```sh
    >foods echo apple
    >>foods echo celery
    >>foods echo cheese
```

   11. new file created is in *working directory*

```sh
    ls -la
    cat foods
```

   12. no change under `.git/` ... just workdir

```sh
    tree .git
```

   13. *workdir* content reported

```sh
    git status
```

### 5.2 `git add`: *staging* blobs

   - git add: The first objects (blobs)

   14. add to *staging* (AKA *index* AKA *cache*)

```sh
    git add foods
```

   15. check `.git/index` and files under `.git/objects/`

```sh
    tree .git
```

   16. *staged* content reported

```sh
    git status
```

   17. view *staged* contents *blob*

```sh
    git cat-file -p bf355d87f9
```

   18. check size of binary `index` file

```sh
    wc -c .git/index
```

### 5.3 `git rm --cached`: *Unstaging*

   - alternatively: `git reset -- file-to-unstage`

   19. unstage the file

```sh
    git rm --cached foods
```

   20. confirm unstaging

```sh
    git status
```

   21. previously staged blobs await GC

```sh
    tree .git
```

   22. smaller size because nothing staged now

```sh
    wc -c .git/index
```

   - note the need for git repo blobs garbage collection

### 5.4 Stage again

   23. will change index contents again

```sh
    git add foods
```

   24. changed back to previous size

```sh
    wc -c .git/index
```

   25. confirm staging

```sh
    git status
```

   26. nothing changed (still fails)

```sh
    git log
```

## 6. Commit (and the branch *reference*)

### 6.1 The first commit

   - git commit: The first commit objects and *reference*
   - other commands
      - git log


   27. first commit

```sh
    git commit --author="Alice <alice>" -m created
```

   28. view commits (at last a *log*)

```sh
    git log
```

   29. previous staged objects no longer there

```sh
    git status
```

   30. new staging index

```sh
    wc -c .git/index
```

### 6.2 Commit trees and blobs dissected

   31. new toplevel `logs/`, more objects and `COMMIT_EDITMSG`

```sh
    tree .git
```

   32. commit contents

```sh
    git cat-file -p 2080c5844
```

   33. tree contents

```sh
    git cat-file -p 99972425
```

   34. the file contents

```sh
    git cat-file -p bf355d87f
```

   35. commit message is maintained (for conflict resolution commits)

```sh
    cat .git/COMMIT_EDITMSG
```

### 6.3 Commit `HEAD` *references*

   36. points to branch HEAD

```sh
    cat .git/HEAD
```

   37. points to branch `HEAD` revision

```sh
    cat .git/refs/heads/master
```

   38. tag this revision so we may return

```sh
    git tag v1
```

   - See for more details:
      - [how is git commit sha1 formed](https://gist.github.com/masak/2415865)


## 7. Commit with *one* parent

### 7.1 Abel or Cain commit

   - the first commit is *Adam* (parentless)
   - all other commits have parent(s)

   39. make changes

```sh
    >>foods echo eggs
    >>foods echo grape
    >>foods echo lettuce
```

   40. incrementally stage changes

```sh
    git add -p .
```

   41. Ready to commit

```sh
    git commit --author="Bob <bob>" -m middle
```

### 7.2 Check new commit `git` internals

   42. Check the commit blob

```sh
    git cat-file -p 548b3cf
```

   43. Check the commit's tree object

```sh
    git ls-tree c146d446da
```

   44. Commit object can be treated as a tree object also

```sh
    git ls-tree 548b3cf
```

   45. view new blob of data

```sh
    git cat-file -p bc6ef76a1a
```

### 7.3 Contrast with parentless (first ever) commit

   46. contrast with parentless commit

```sh
    git cat-file -p 548b3cf
    git cat-file -p 2080c5
```

   47. points to branch HEAD

```sh
    cat .git/HEAD
```

   48. points to where HEAD is now

```sh
    cat .git/refs/heads/master
```

   49. we have history

```sh
    git log
```

## 8. Branch is cheap

### 8.1 Cheap and chic

   - branching is cheap!
   - branching creates only a reference (**no** new blobs, trees, commits)
   - only problem is mental overhead of managing branches
      - naming
      - deleting
      - merging
      - pushing

   - commands:
      - git branch
      - git checkout
      - git show
      - git diff --cached

### 8.2 Branch off some point in history


   50. create a new branch (but stay where we are)

```sh
    git branch feature/menu-expansion 2080c5
```

   51. check new refs

```sh
    tree .git
```

   52. new branch HEAD

```sh
    cat .git/refs/heads/feature/menu-expansion
```

   53. check the branch next to 1st commit

```sh
    git log
```

### 8.3 `git checkout`: goto branch

   54. change workdir to where branch HEAD is

```sh
    git checkout feature/menu-expansion
```

   55. confirm we've moved

```sh
    git log
```

   56. no changes in working dir or staging

```sh
    git status
```

   57. confirm we are back in time

```sh
    cat foods
```

   58. `master` branch content differs

```sh
    git show master:foods
```

### 8.4 A bad start on the branch

   59. more food

```sh
    >>foods echo milk
```

   60. changes in working dir (not staged yet)

```sh
    git status
```

   61. see working dir changes

```sh
    git diff
```

   62. scrap working dir changes (checkout branch HEAD as workdir)

```sh
    git checkout .
```

   63. no changes anywhere

```sh
    git diff
```

### 8.5 Stage work for branch

   64. more food

```sh
    >>foods echo milk
    >>foods echo orange
    >>foods echo peas
```

   65. working dir changes

```sh
    git diff
```

   66. stage changes

```sh
    git add foods
```

   67. nothing new in working dir

```sh
    git diff
```

   68. check staged changes

```sh
    git diff --cached
```

### 8.6 Commit to branch

   69. Carol commits

```sh
    git commit --author="Carol <carol>" -m last
```

   70. same parent as `HEAD` of master

```sh
    git cat-file -p 251db71
```

   71. check the new blob

```sh
    git cat-file -p ...
```

   72. log reflects new changes

```sh
    git log
```

## 9. Merge can be ... hell!

### 9.1 Merge ... directions

   - `git merge` means *"****bring*** *here and mix"*
   - we merge another branch ***into the current*** **branch**
   - optimistic "locking" means we could have to deal with conflicts

### 9.2 Prepare to merge

   73. tips of the snake's tongue

```sh
    git log --graph --decorate --all
```

   74. nothing staged or in working dir

```sh
    git status
```

   75. `HEAD`'s pointing to ...

```sh
    cat .git/HEAD
```

   76. branch `HEAD` points to ...

```sh
    cat .git/refs/heads/feature/menu-expansion
```

### 9.3 Merge conflict

   77. switch to master branch

```sh
    git checkout master
```

   78. still nothing staged or in working dir

```sh
    git status
```

   79. now HEAD's pointing to ...

```sh
    cat .git/HEAD
```

   80. check `master HEAD` commit

```sh
    cat .git/refs/heads/master
```

   81. business as usual

```sh
    tree .git
```

   82. *ready?*

```sh
    git merge feature/menu-expansion # feel the pain
```

### 9.4 Dealing with the mess

   83. the familiar mess

```sh
    cat foods
```

   84. shows status and suggestions

```sh
    git status
```

   85. where is my `HEAD`?

```sh
    cat .git/HEAD
```

   86. `HEAD` didn't move from `master`

```sh
    cat .git/refs/heads/master
```

### 9.5 Merge conflict `git` internals (part 1)

   87. look into the abyss

```sh
    tree .git
```

   88. `AUTO_MERGE`?

```sh
    cat .git/AUTO_MERGE
```

   89. `MERGE_HEAD`?

```sh
    cat .git/MERGE_HEAD
```

   90. the feature branch HEAD

```sh
    git log -1 $(cat .git/MERGE_HEAD)
```

### 9.5 Merge conflict `git` internals (part 2)

   91. nothing here

```sh
    cat .git/MERGE_MODE
```

   92. the message to assist with committing later on

```sh
    cat .git/MERGE_MSG
```

   93. What changes did I make to resolve conflicts so far?

```sh
    git cat-file -p $(cat .git/AUTO_MERGE)
```

   94. check contents with conflict

```sh
    git cat-file -p 4e5e86
```

### 9.6 `git merge --abort`: backing off!

   95. Abort the whole ordeal

```sh
    git merge --abort 
```

   96. `*MERGE*` files disappeared

```sh
    tree .git
```

## 10. Merge commit (and parents)

### 10.1 Merge commit as we know it

   - resolve the conflict
   - merges (as we know them) have more than one parent
   - merged history is interleaved branches history

### 10.2 Merge again

   97. merge

```sh
    git merge feature/menu-expansion
```

   98. what a mess!

```sh
    git diff
```

   99. nothing to see here

```sh
    git diff --cached
```

### 10.3 Resolve at last

   100. resolve conflict

```sh
    vim foods
```

   101. looks better

```sh
    git diff
```

   102. stage it

```sh
    git add foods
```

   103. staged changes

```sh
    git diff --cached
```

   104. new blob created, index changed

```sh
    tree .git
```

   105. relevant blob object

```sh
    git cat-file -p ...
```

### 10.4 The merge commit (at last)

   106. merged work committed

```sh
    git commit
```

   107. check commit blob's contents

```sh
    git cat-file -p 755b5f8
```

   108. check commit blob's parents

```sh
    git cat-file -p ...; git cat-file -p ...
```

   109. check merge commit's tree object

```sh
    git ls-tree ...
```

   110. confirm it points to new contents

```sh
    git cat-file -p ...
```

   111. the history is interleaved

```sh
    git log
```

## 11. Fast-forward merges

### 11.1 Fast-forward merges are a delight!

   - `git merge` work that progressed while main branch (`master`?) kept still
   - fast-forward merges don't get conflicts!
   - fast-forward merges don't get interleaved history!
   - best scenario for the person merging (into `master`)
      - they will *not* have to resolve conflicts!
   - *it's as if we never branched!*

### 11.2 Working on a hotfix

   112. work on a *quick* hotfix

```sh
    git checkout -b hotfix/quick
```

   113. fix quick!

```sh
    >>foods echo curry
```

   114. stage and ...

```sh
    git add foods
```

   115. ... fast, commit!

```sh
    git commit --author="David <david>" -m delicious
```

### 11.3 A piece of good fortune

   116. note that we are ahead of `master`

```sh
    git log
```

   117. checkout `master` branch

```sh
    git checkout master
```

   118. notice the **fast-forward** mention

```sh
    git merge hotfix/quick
```

   119. shows that `master` and `hotfix/quick` point to same commit

```sh
    git log -2
```

   120. just one parent

```sh
    git cat-file -p 0f7221d
```

## 12. Rebasing

### 12.1 What is `rebase`?

   - `rebase`: the current branch commits are ...
      - ... based onto something new
      - ... floated on top of another commit

   - we rebase the current branch ***onto*** another branch
      - ***BUT*** we stay in the ***current*** **branch**
      - the other branch is ***not*** **modified**
      - the current branch history changes ... *"toxically"*


### 12.2 Let's try rebasing ...

   121. go back to `v1`

```sh
    git reset --hard v1
```

   122. checkout a branch to rebase

```sh
    git checkout feature/menu-expansion
```

   123. confirm that we've diverged

```sh
    git log
    git log master
```

   124. rebase ***onto*** `master`

```sh
    git rebase master   # conflict like with merge
```

   125. we're left in the middle of rebasing

```sh
    git status  # note the instructions in output
```

### 12.3 Resolve and `continue` the `rebase`

   126. the familiar mess

```sh
    git diff
```

   127. resolve conflicts

```sh
    vim foods
```

   128. stage the resolution

```sh
    git add foods
```

   129. What changes did I make to resolve conflicts so far?

```sh
    git cat-file -p $(cat .git/AUTO_MERGE)
```

   130. *continue* with the rebase

```sh
    git rebase --continue
```

   131. confirm the rebase in the log

```sh
    git log
```

### 12.4 To `rebase` is divine

   - **rebase** ***before*** **merging**
   - conflicts are resolved ***in*** the branch that rebases (current branch)
   - rebasing ...
      - ... paves the way to the (blissful) *fast-forward merge*
      - ... ensures contiguous, localized commits
      - ... leads to readable git history
      - ... is a way of the Tao


## 13. Conclusions

### 13.1 Let's recap

   - all of `git`'s knowledge of your project is in `.git` folder
      - remove `.git` folder and we lost all version information for the project
   - `git` takes snapshots of your code and stores them as blobs under `.git`
   - the deltas we see (`git diff`) are *computed* from the blobs, they are not stored

### 13.2 So what?

   - `git` is cheap
      - it re-uses blobs
      - it is fast
      - it is safe

   - take advantage of version control in even the silliest, *"just to test"* projects
      - scrap the project's history easily (delete `.git`) once done, or
      - leave the history there for our future self
      - feel safe to experiment (*branch* or not)

