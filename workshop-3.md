# Everyday `git`

## 1. Understanding git diff

### 1.1 Line changes

   - it's easier than you think

   - a few changed lines:

\tiny
```
    ~$ git diff HEAD~1..HEAD
    diff --git a/src/Service/InvoiceServices.cs b/src/Service/InvoiceServices.cs
    index 31ecf7f..aa7fe32 100644
    --- a/src/Service/InvoiceServices.cs
    +++ b/src/Service/InvoiceServices.cs
    @@ -149,7 +149,7 @@ namespace Danaos.AlmiIntegrator.Service
                , analysis.SupplierCode
                , allEntriesCount
                , accEntry
    -           , analysis.SupportingDocuments.Select(att => att.Filename)));
    +           , attachmentPaths));
         analysis
            .OffAccountingReversals
            .ForEach(reversal => PersistOffAccountingReversal(uniqRefId
```
\normalsize

### 1.2 New file addition

   - a new file added

\tiny
```
    ~$ git diff HEAD~1..HEAD
    diff --git a/Makefile b/Makefile
    new file mode 100644
    index 0000000..f7667ae
    --- /dev/null
    +++ b/Makefile
    @@ -0,0 +1,17 @@
    +all: rename
    +
    +SRC = ./tmp
    +DFLT_DEV = unknown@eurotankers.gr
    +
    +# Find all EML filenames without an email address in filename
    +/tmp/rename-eml.log: ./Makefile
    +       @find $(SRC) -type f -name "*[0-9].eml" > /tmp/rename-eml.log
```
\normalsize

### 1.3 File deletion

   - a file deleted

\tiny
```
    ~$ git diff
    diff --git a/imap-get.sh b/imap-get.sh
    deleted file mode 100644
    index ef85b15..0000000
    --- a/imap-get.sh
    +++ /dev/null
    @@ -1,6 +0,0 @@
    -
    -until DBUSER=danaos perl /DMS/queue/convert/bin/step1-delta.pl $1
    -do
    -  echo "Retrying"
    -  sleep 5
    -done
```
\normalsize

## 2. Delete / rename branches

### 2.1 Delete branch

   - Deleting a branch is something you will often need:

```sh
    (master)$ git branch -D hotfix/job-done
```

   - you often need to delete the branch on some remote repository and this involves `push`ing:

```sh
    (master)$ git push -d origin hotfix/job-done
```

### 2.2 Rename branch

   - Renaming a branch is also convenient

```sh
    $ git branch -m hotfix/not-again hotfix/21a-666
```

   - Renaming a remote branch involves
      - pushing the locally renamed branch
      - deleting remote (`origin`) old branch name

## 3. Picking commits

### 3.1 cherry-pick commit (quick and dirty)

   - sometimes you just want to pick the work of a single commit
   - this can be done with `git cherry-pick`:

```sh
    (feature/wip)$ git cherry-pick c355791c
```

   - often this is ***NOT*** **what we want**
      - unless working on a scrap-away branch of our own
      - and not planning to merge with that branch ...
         - ... or its descendants

   - **The problem with cherry-picking is that rebase / merge lead to conflict!**

### 3.2 cherry-pick commit (slow but promising)

   - *interactive rebasing* (`git rebase -i`) to the rescue
   - often you can place the *cherry* after the destination branch's `HEAD`
   - in the example that follows ...

### 3.2 cherry-pick commit (example)

   - let's say we want to cherry-pick `part2` commit's work

\tiny
```sh
    ~ (feature/long)$ git log
    commit 96d9a61b8371b23ec3611ccee3e103bf06489368 (HEAD -> feature/long)
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:17:08 2021 +0200
    
        part3
    
    commit 2de9aa9bd825feeaf60dc1027b8170f358e2692e
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:16:55 2021 +0200
    
        part2
    
    commit 8c5d682125f2cf8cbb1cee01b7fe81de070ebcd8
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:16:41 2021 +0200
    
        part1
    
    commit 7106d102aa95e4a683fe8a0de804fc2a14a51b78 (master)
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:19:32 2021 +0200
    
        almost ready
    
    commit faf769a9e451ee344f02f411914d7abcbc692195
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:03:30 2021 +0200
    
        created
```
\normalsize

### 3.2 cherry-pick commit (interactive rebase)

   - push `part2` next to `master` branch's `HEAD`

\tiny
```sh
    ~ (feature/long)$ git rebase -i master~1
    Successfully rebased and updated refs/heads/feature/long.
    ~ (feature/long)$ git log
    commit bc77fce5345055b46e7c8e1c53ea6e9e30501d16 (HEAD -> feature/long)
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:17:08 2021 +0200
    
        part3
    
    commit f08740db559260a50653e2d42c8fe10882824352
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:16:41 2021 +0200
    
        part1
    
    commit 3f0a62f060444c153fb43cf39411bb24240ba1aa
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:16:55 2021 +0200
    
        part2
    
    commit 7106d102aa95e4a683fe8a0de804fc2a14a51b78 (master)
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:19:32 2021 +0200
    
        almost ready
    
    commit faf769a9e451ee344f02f411914d7abcbc692195
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:03:30 2021 +0200
    
        created
```
\normalsize

### 3.2 cherry-pick commit (ready)

   - `merge` to `cherry-pick`

\tiny
```sh
    ~ (feature/long)$ git checkout master
    Switched to branch 'master'
    ~ (master)$ git merge 3f0a62f0
    Updating 7106d10..3f0a62f
    Fast-forward
     foods | 1 +
     1 file changed, 1 insertion(+)
    ~ (master)$ git log -4 feature/long 
    commit bc77fce5345055b46e7c8e1c53ea6e9e30501d16 (feature/long)
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:17:08 2021 +0200
    
        part3
    
    commit f08740db559260a50653e2d42c8fe10882824352
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:16:41 2021 +0200
    
        part1
    
    commit 3f0a62f060444c153fb43cf39411bb24240ba1aa (HEAD -> master)
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:16:55 2021 +0200
    
        part2
    
    commit 7106d102aa95e4a683fe8a0de804fc2a14a51b78
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:19:32 2021 +0200
    
        almost ready
```
\normalsize

## 4. `git reset`: update `HEAD` ref tricks

### 4.1 Go back one (two, three, ...) commit(s)

   - this is one of the most requested actions
   - get rid of recent / top commits of the branch
   - AKA rewind HEAD to parent (of parent (of parent (..)))
   - to remove the top 2 branch commits

```sh
    $ git reset --hard HEAD~2  # rewind two commits
```

### 4.2 Go back / forth in time

   - frequently needed also

```sh
    $ git reset --hard 600dc0 # HEAD now at 600dc0
```

### 4.3 Split last commit into multiple commits

   - sometimes our huge commit should have been broken down
   - you are asked to push ***a portion of the work*** only
   - `git reset` again (but **not** `--hard`):

```sh
    $ git reset HEAD~1 # keep top commit in workdir
```

   - ... or ...

```sh
    $ git reset --soft HEAD~1 # keep commit staged
```

   - then you can rework the code changes into multiple commits

## 5. A sense of security

### 5.1 Feeling lost

   - sometimes we feel lost
      - we think we're somewhere and ...
      - ... a dozen commands later we "wake up"
      - *"what happened?"*
      - *"how much damage did I do?"*
   - other times we feel lost in a repo we haven't worked on in a while
   - *how can we orient ourselves?*

### 5.2 Sorting branches by most recent commit

   - multiple un-merged branches in some long unseen repo confuse us
   - *"which branch was being worked on last time?"*
   - `git branch -a --sort=-committerdate`
      - orders branches in descending order of commit times

\small
```sh
    ~$ git branch -a --sort=-committerdate 
      feature/menu-expansion
      feature/bob
    * master
```
\normalsize

### 5.3 `git reflog`

   - `git reflog`
   - gives a sense of what we've been up to

\tiny
```sh
    ~$ git reflog 
    38f4db8 (HEAD -> master) HEAD@{0}: reset: moving to @~1
    f624321 HEAD@{1}: merge feature/menu-expansion: Fast-forward
    548b3cf HEAD@{2}: checkout: moving from feature/menu-expansion to master
    f624321 HEAD@{3}: commit: more
    38f4db8 (HEAD -> master) HEAD@{4}: rebase (continue) (finish): returning to refs/heads/feature/menu-expansion
    38f4db8 (HEAD -> master) HEAD@{5}: rebase (continue): last
    548b3cf HEAD@{6}: rebase (start): checkout master
    251db71 HEAD@{7}: checkout: moving from master to feature/menu-expansion
    548b3cf HEAD@{8}: reset: moving to @~1
    755b5f8 HEAD@{9}: commit (merge): Merge branch 'feature/menu-expansion'
    548b3cf HEAD@{10}: reset: moving to HEAD
    548b3cf HEAD@{11}: reset: moving to HEAD
    548b3cf HEAD@{12}: checkout: moving from feature/menu-expansion to master
    251db71 HEAD@{13}: checkout: moving from master to feature/menu-expansion
    548b3cf HEAD@{14}: reset: moving to HEAD
    548b3cf HEAD@{15}: reset: moving to HEAD
    548b3cf HEAD@{16}: checkout: moving from feature/menu-expansion to master
    251db71 HEAD@{17}: commit: last
    2080c58 HEAD@{18}: checkout: moving from master to feature/menu-expansion
    548b3cf HEAD@{19}: commit: middle
    2080c58 HEAD@{20}: commit (initial): created
```
\normalsize

## 6. `git` trouble!

### 6.1 Recursive `.git` folders

   - we might
      - initialize `git` repositories inside other repositories, or
      - add git repositories inside other repositories
   - it often happens by mistake
   - `git` will complain but will permit it

### 6.1 Recursive `.git` folders *(submodule)*

   - the warning `git` gives talks about *submodule* addition:

\tiny
```
    $ git add recursive-git/
    warning: adding embedded git repository: recursive-git
    hint: You've added another git repository inside your current repository.
    hint: Clones of the outer repository will not contain the contents of
    hint: the embedded repository and will not know how to obtain it.
    hint: If you meant to add a submodule, use:
    hint: 
    hint: 	git submodule add <url> recursive-git
    hint: 
    hint: If you added this path by mistake, you can remove it from the
    hint: index with:
    hint: 
    hint: 	git rm --cached recursive-git
    hint: 
    hint: See "git help submodule" for more information.
```
\normalsize

   - if we ignore this message:
      - a *submodule* will get added
      - we may later recognize the problem in **inconsistent** history logs

### 6.2 *`git stash` considered harmful*

   - `git stash` is misused
   - avoid unless you like its
      - *stack logic*
      - *unintuitive* tree object descriptions
   - `git stash` is not a branching alternative
      - 99% of time we need to *branch* instead
   - `git stash` will get us into trouble one day!
   - classic problem
      - popping stash full of conflicts, and
      - being unable to get out of resolve conflict mode

### 6.3 When to use `git stash`

   - when is `git stash` helpful?
   - usually after `git add -p`
      - there's workdir changes we didn't commit
      - we want to be sure most recent commit compiles

```sh
    ~$ git add -p . # stage only some work
    ~$ git commit   # commit
    ~$ git stash    # stash uncommitted
    ~$ make         # compiles / tests ok
    ~$ git stash pop  # get back to work
```

   - references
      - [git stash (pop) considered harmful](https://codingkilledthecat.wordpress.com/2012/04/27/git-stash-pop-considered-harmful/)

## 7. Fragments of a dev's workflow

### 7.1 Various tricks

   - there's lots of tricks
   - *branches namespacing* is a good first step

   - ***You are responsible for the state of you local repository!***

### 7.2 The *special config* branch (intro)

   - we get assigned `johndoe`'s project
   - `johndoe` committed VS config files (`.vs`) with paths on **his** machine
      - paths on **our** machine are **different**
   - *do we commit and push our paths?*

### 7.2 The *special config* branch (cfg branch)

   - instead of pushing our paths and returning bad karma

   - Create a local cfg branch with local cfg details

\small
```sh
    ~$ git checkout -b cfg/jessicadoe
    ~$ vim .vs/config/applicationhost.config # local paths
    ~$ git add -f .vs/config/applicationhost.config
    ~$ # used -f because it's in .gitignore
    ~$ git commit -m "local cfg to use to rebase"
```
\normalsize

### 7.2 The *special config* branch (cfg branch use)

   - now after fetching latest work of others

\small
```sh
    ~$ git fetch
    ~$ git checkout feature/new-from-jdoe # has bad cfg
    ~$ git cherry-pick cfg/jessicadoe # get working cfg
```
\normalsize

   - after committing our work on the feature
      - we need to drop the cherry picked local configuration

```sh
    ~$ # drop local config commit
    ~$ git rebase -i origin/feature/new-from-jdoe~1
    ~$ # note 'origin/' above
    ~$ git push
```

### 7.3 Push to backup

   - remember the **D** in DVCS?
   - we know that `Q:` shared drive is backed up
   - quick solution to backing up our work
      - until ready to merge
      - so that we don't polute central repo with our WIP branch

\small
```sh
    ~$ git remote add backup /Q/jessicadoe/git-bak/proj
    ~$ git push backup feature/not-yet-complete
```
\normalsize

## 8. Pull requests workflow

### 8.1 Workflow model overview

   - this model is popular on the internet
   - it means we can't directly push to `official/proj-name`
   - what we do is ***fork*** `official/proj-name`
      - ***fork*** = `clone` + "logistics"
   - now we can push to `jessicadoe/official-proj-name`
      - `jessicadoe/official-proj-name` is a *fork*
   - ***pull requests*** to `official/proj-name` are
      - made of pushes to `jessicadoe/official-proj-name`
      - made possible by *fork* "logistics"

### 8.2 An example

   - let's assume urgent issue codenamed: *tragedy*
      - we fix the issue
      - we push `fix/tragedy` to `jessicadoe/official-proj-name`
      - we send *pull request* to `official/proj-name`
         - i.e. *"please merge `fix/tragedy`"*
   - the *pull request*
      - will be reviewed, and
      - will (hopefully) be merged into their *main* branch
   - it's *also possible* the *pull request*
      - will *not* be accepted
      - review comments may / may not be returned
      - may be completely ignored

### 8.3 The brilliance of **D**VCS

   - the distributed nature of `git` enables
      - different sub-product/module branches with different reviewers
      - module reviewers merging pull requests, and
      - modules pulled into main product branches
   - ***possibly the safest model on big teams!***

