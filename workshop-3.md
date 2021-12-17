# 3. Everyday git (... trouble!)

   - difference between git:// and https://
      - the need for ssh keys

## 3.1 Recursive .git folders *(subprojects)*

   - people forget and initialize git repositories inside other repositories
   - it often happens in huge projects
   - git will not make a huge fuss about it
   - if you are *(you are!)* the kind that does not read command feedback you will realize ages later
   - the feedback you'd get from git at the time you create the subproject:

```sh
    (master)$ git add recursive-git/
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

   - if you ignore this message you may later recognise the problem in inconsistent history logs

## 3.2 Delete / rename branch

   - Deleting a branch is something you will often need:

```sh
    (master)$ git branch -D hotfix/job-done
```

   - you often need to delete the branch on some remote repository and this involves `push`ing:

```sh
    (master)$ git push -d origin hotfix/job-done
```

## 3.3 `git reset`: update `HEAD` refs

### 3.3.1 Go back one (two, three, ...) commit(s)

   - this is one of the most requested actions
   - get rid of top commits of the branch
   - AKA rewind HEAD to parent (of parent (of parent (..)))
   - to remove the top 2 branch commits

```sh
    (feature/wip)$ git reset --hard HEAD~2  # two commits HEAD rewind
```

### 3.3.2 Go back / forth in time

   - frequently needed also

```sh
    (feature/wip)$ git reset --hard 600dc03317  # HEAD is now 600dc03317
```

### 3.3.3 Split last commit into multiple commits

   - sometimes you have to do a huge task that should have been broken down to smaller ones
   - not all of the task is finished and you are asked to push only ***a portion of the work*** you have done
   - `git reset` (but not `--hard`) to the rescue:

```sh
    (feature/wip)$ git reset HEAD~1   # rewind HEAD but keep the top commit work in WORKING dir
```

   - ... or ...

```sh
    (feature/wip)$ git reset --soft HEAD~1   # rewind HEAD but keep the top commit work in STAGING
```

   - then you can rework the code changes into multiple commits

## 3.4 Git cherry-pick and almost cherry-pick

   - sometimes you just want to pick the work of a single commit
   - this can be done with `git cherry-pick`:

```sh
    (feature/wip)$ git cherry-pick c355791c   # rewind HEAD but keep the top commit work in STAGING
```

   - ***BUT*** often it isn't what you really want.
   - ... unless you are working on a scrap-away branch of your own, or ...
   - ... you are not planning on merging with the branch you cherry-picked from.
   - The problem with cherry-picking is that rebase / merge then lead to conflicts

### An alternative to cherry-picking

   - *interactive rebasing* (`git rebase -i`) to the rescue
   - often you can get the *cherry* by getting your branch HEAD to be its parent:

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
    ~ (feature/long)$ git checkout master
    Switched to branch 'master'
    ~ (master)$ git merge 3f0a62f0
    Updating 7106d10..3f0a62f
    Fast-forward
     foods | 1 +
     1 file changed, 1 insertion(+)
    ~ (master)$ git log feature/long 
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
    
    commit faf769a9e451ee344f02f411914d7abcbc692195
    Author: Evangelos Tsagkas <etsagkas@danaos.gr>
    Date:   Thu Dec 16 11:03:30 2021 +0200
    
        created
```

## 3.X Git stash considered harmful

   - `stash` is not as convenient as it looks
      - it follows stack logic
      - unintuitive tree object descriptions
   - `stash` is not as powerful as branching and committing
   - `stash` will get you into trouble one day!
      - common problem is popping stash full of conflicts and being unable to get out of resolve conflict mode
   - when is stash helpful?
      - after `git add -p` you want to make sure your commit compiles

```sh
    ~$ git add -p .
    ~$ git commit
    ~$ git stash
    ~$ make
    ~$ git stash pop
```

   - references
      - [git stash (pop) considered harmful](https://codingkilledthecat.wordpress.com/2012/04/27/git-stash-pop-considered-harmful/)

## 3.5 Reflog: a sense of security

## 3.X Understanding git diff

## 3.X Pull requests workflow

## 3.X Fragments of a developer's workflow
### 3.X The special configuration branch
### 3.X The push to origin as backup
### 3.X Branches namespacing or taking care of your branches
#### 3.X Temporary branches

