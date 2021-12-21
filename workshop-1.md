# The training sessions

## 1. VCS (part 1)

### 1.1. Introduction to VCS

   - RCS
   - CVS
   - Subversion was the first sexy VCS
   - ***pessimistic locking*** (focusing on conflict avoidance instead of conflict resolution) was a bad idea

### 1.2 git as VCS

   - works nicely for one dev only
   - works for any size of project
   - git tracks ***data*** and a ***DAG*** (graph)
   - git does **NOT** really track filesystem constructs (i.e. filenames, directories, inodes)
      - `git mv` (i.e. *rename*) is a hack!
      - file or directory names (even branch names) can lead to issues in interplay between case in/sensitive FS.
   - git fundamentals are:
      1. Objects:
         1. ***blobs***
         2. ***trees***
         3. ***commits***
      2. Naming system for the objects:
         1. ***references***
      - See for more details:
         - [A Visual Guide to Git Internals](https://www.freecodecamp.org/news/git-internals-objects-branches-create-repo/)

### 1.3 Work session explained

   - local git, with no remote
   - before we start:

```sh
    git config --global core.editor "/c/Windows/System32/notepad.exe"
    alias tree=tree.com
```

#### 1.3.1 Repository creation

   1. `ls -la`     # an empty directory
   2. `git status` # fails
   3. `git init`
   4. `ls -la`     # git init created .git/ and it's contents
   5. `git status` # git is alive
   6. `git log`    # fails
   7. `tree .git`
   8. `rm .git/hooks/*`  # to focus on important stuff
   9. `tree .git`

#### 1.3.2 *Staging*: objects without reference

   - git add (-p): The first objects (blobs and +TODO: trees)
   - the need for garbage collection

   10. `>foods echo apple`
   11. `ls -la; cat foods` # A new file created in working dir
   12. `tree .git`   # no change under .git/ ... just workdir
   13. `git add foods` # this changes .git/ contents
   14. `tree .git`   # check index and files under objects/ subdirs
   15. `git status`  # reflects staged contents
   16. `git log   `  # still fails
   17. `git cat-file -p bf355d87f92649d8b22a9beda5136e1a6acc1fa3` # shows file contents staged
+TODO: git ls-tree ...
   18. `wc -c .git/index`      # binary format; check size
   19. `git rm --cached foods` # unstage the file
   20. `git status`  # confirm unstaging
   21. `tree .git`   # previously staged blobs await GC
   22. `wc -c .git/index`  # smaller size; nothing staged now
   23. `git add foods`     # will change index contents again
   24. `wc -c .git/index`  # changed back to previous size
   25. `git status`  # confirm staging
   26. `git log`     # nothing changed; still fails

   - other commands
      - git status
      - git rm --cached
      - git diff --cached

### 1.3.3 Commit and the branch reference

   - git commit: The first commit objects and reference
   - other commands
      - git log

   27. `git commit --author="Alice <alice>" -m created`  # first commit
   28. `git log`           # view commits
   29. `git status`        # previous staged objects no longer there
   30. `wc -c .git/index`  # new staging index
   31. `tree .git`         # new toplevel logs/, more objects and COMMIT_EDITMSG
   32. `git cat-file -p 2080c5844204aa95bd2d9a6f54db449117e22417` # commit contents
   33. `git cat-file -p 999724252ad70173e02541d2920f01cb797a53b5` # tree contents
   34. `git cat-file -p bf355d87f92649d8b22a9beda5136e1a6acc1fa3` # the file contents
   35. `cat .git/COMMIT_EDITMSG`
   36. `cat .git/HEAD`               # points to branch HEAD
   37. `cat .git/refs/heads/master`  # points to where we are now
   38. `git tag v1`

   - See for more details:
      - [how is git commit sha1 formed](https://gist.github.com/masak/2415865)

### 1.3.4 Commit with one parent

   - the first commit is Adam (parentless)
   - all other commits have parent(s)

   38. make changes

```sh
    >>foods echo eggs
```

   39. incrementally stage changes

```sh
    git add -p .
```

   40. Ready to commit

```sh
    git commit --author="Bob <bob>" -m middle
```

   41. Check the commit blob

```sh
    git cat-file -p 548b3cf
```

   42. Check the commit's tree object

```sh
    git ls-tree c146d446dadf5555bd5701f964f796522c421be0
```

   43. Commit object can be treated as a tree object also

```sh
    git ls-tree 548b3cf
```

   44. view new blob of data

```sh
    git cat-file -p bc6ef76a1a30a308b78bc4eb6a5f9141496635bd
```

   45. contrast with parentless commit

```sh
    git cat-file -p 548b3cf
    git cat-file -p 2080c5
```

   46. points to branch HEAD

```sh
    cat .git/HEAD
```

   47. points to where HEAD is now

```sh
    cat .git/refs/heads/master
```

   48. we have history

```sh
    git log
```

### 1.3.5 Branching is cheap and easy

   - branching is cheap!
   - branching creates only a reference (**no** new blobs, trees, commits)
   - commands:
      - git branch
      - git checkout
      - git show

   49. `git branch feature/menu-expansion 2080c5`  # create a new branch
   50. `tree .git`       # check new refs
   51. `cat .git/refs/heads/feature/menu-expansion` # new branch HEAD
   52. `git log`         # check the branch next to 1st commit
   53. `git checkout feature/menu-expansion` # go back in time
   54. `git log`
   55. `git status`      # no changes in working dir or staging
   56. `cat foods`       # we are back in time
   57. `git show master:foods`	# this is the present so far
   58. `>>foods echo nilk`
   59. `git status`      # unstaged changes in working dir
   60. `git diff`        # see unstaged changes diff
   61. `git checkout .`  # scrap working dir changes; go to HEAD
   62. `git diff`        # no changes anywhere
   63. `>>foods echo milk`
   64. `git diff --cached` # nothing staged yet
   65. `git diff`          # working dir changes
   66. `git add foods`
   67. `git diff --cached` # staged changes
   68. `git diff`          # nothing new in working dir
   69. `git commit --author="Carol <carol>" -m last`
   70. `git cat-file -p 251db71`  # same parent as HEAD of master
   71. `git cat-file -p ...`      # check the new blob
   72. `git log`

### 1.3.6 Merge conflict

   - git merge means "bring here and mix"
   - you merge another branch ***into*** the current branch
   - optimistic "locking" means with have to deal with conflicts
   - git merge
   - git merge --abort

   73. `git log --graph --decorate --all`  # tips of the snake's tongue
   74. `git status`   # nothing staged or in working dir
   75. `cat .git/HEAD`        # HEAD's pointing to ...
   76. `cat .git/refs/heads/feature/menu-expansion`
   77. `git checkout master`  # switch to master branch
   78. `git status`   # stil nothing staged or in working dir
   79. `cat .git/HEAD`        # now HEAD's pointing to ...
   80. `cat .git/refs/heads/master`  # check master HEAD commit
   81. `tree .git`   # business as usual
   82. `git merge feature/menu-expansion` # feel the pain
   83. `cat foods`    # the familiar mess
   84. `git status`   # shows status and suggestions
   85. `cat .git/HEAD` # where is my HEAD?
   86. `cat .git/refs/heads/master` # HEAD didn't move from master
   87. `tree .git`   # look into the abyss
   88. `cat .git/AUTO_MERGE`
   89. `cat .git/MERGE_HEAD`
   90. `git log -1 $(!!)` # the feature branch HEAD
   91. `cat .git/MERGE_MODE`  # nothing here
   92. `cat .git/MERGE_MSG`   # the message to assist with committing later on
   93. `git cat-file -p $(cat .git/AUTO_MERGE)`
   94. `git cat-file -p 4e5e86` # check contents with conflict
   95. `git merge --abort 
   96. `tree .git`   # no more *MERGE* files

### 1.3.7 Merge commit parents

   - resolve the conflict
   - merges (you're used to) have more than one parent
   - merged history is interleaved branches history

   97. `git merge feature/menu-expansion`
   98. `git diff`           # what a mess
   99. `git diff --cached`  # nothing to see here
   100. `vim foods`         # resolve conflict
   101. `git diff`          # looks better
   102. `git add foods`     # staged
   103. `git diff --cached` # staged changes
   104. `tree .git`        # new blob created, index changed
   105. `git cat-file -p ...`     # relevant blob object
   106. `git commit`        # merged work committed
   107. `git cat-file -p 755b5f8` # check commit blob's contents
   108. `git cat-file -p ...; git cat-file -p ...` # check commit blob's parents
   109. `git ls-tree ...`     # check merge commit's tree object
   110. `git cat-file -p ...` # confirm it points to new contents
   111. `git log`             # the history is interleaved

### 1.3.8 Fast-forward merges

   - git merge work that progressed while main branch (`master`?) kept still
   - fast-forward merges don't get conflicts!
   - fast-forward merges don't get interleaved history!
   - best scenario for the person merging (into `master`) not to have to resolve conflicts!

   112. `git checkout -b hotfix/quick`
   113. `>>foods echo curry`
   114. `git add foods`
   115. `git commit --author="David <david>" -m delicious`
   116. `git log`   # confirm that you are ahead of master
   117. `git checkout master`
   118. `git merge hotfix/quick`  # notice the fast-forward mention
   119. `git log -2` # shows that master and hotfix/quick point to same commit
   120. `git cat-file -p 0f7221d` # just one parent


### 1.3.9 Rebasing

   - rebasing takes place before merging
   - you rebase the current branch ***onto*** another branch (without modifying in)
   - it paves the way to the fast-forward merge
   - conflicts are resolved by whoever worked on the branch
   - rebasing ensures contiguous, localized commits
   - it leads to readable git history
   - it is a way of the Tao

   - git rebase
   - git reset --hard

   121. `git reset --hard v1`  # let's go back
   122. `git checkout feature/menu-expansion`
   123. `git log`
   124. `git log master`
   125. `git rebase master` # conflict but this time branch dev handles it
   126. `git status`  # status and directions
   127. `git diff`    # looks fimiliar
   128. `vim foods`   # resolve conflicts
   129. `git add foods`
   130. `git rebase --continue`
   131. `git log`

### 1.4 Conclusions

   - all of git's knowledge of your project is in the `.git` sub-folder
      - remove `.git` sub-folder and you lost all version information for the specific project
   - git takes snapshots of your code and stores them as blobs under `.git`
   - the deltas (git diff) you see are computed from the blobs, they are not stored
   - git is cheap
      - it is fast
      - it re-uses blobs
   - you can take advantage of version control for the silliest, temporary, little, insignificant projects
      - you can scrap the project's history easily once you're done if you're concerned about space
      - you can leave the history there for your future self to remember what you were up to in the past
