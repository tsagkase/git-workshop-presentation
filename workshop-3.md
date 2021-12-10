# 3. Everyday git (... trouble!)

   - difference between git:// and https://
      - the need for ssh keys

## 3.X Recursive .git folders (BAD)

## 3.X Delete branch

## 3.X Git cherry-pick and almost cherry-pick

   - almost cherry-pick = rebase -i and git branch cherry/branch specific-commit and git merge

## 3.X Go back one (two, three, ...) commit(s)

   - git gotchas
      - git reset -- 

## 3.X Understanding git diff

## 3.X Git stash considered harmful

   - `stash` is not convenient
      - it follows stack logic
      - it has unhelpful descriptions
   - `stash` is not as powerful as branching and committing
   - `stash` will get you into trouble one day
      - common case is popping stash full of conflicts and not being able to get out of resolve conflict mode
   - when is stash helpful?
      - after `git add -p` you want to make sure your commit compiles

```sh
    git add -p .
    git commit
    git stash
    make
    git stash pop
```

   - references
      - [git stash (pop) considered harmful](https://codingkilledthecat.wordpress.com/2012/04/27/git-stash-pop-considered-harmful/)

## 3.X Reflog: a sense of security

## 3.X Pull requests workflow

## 3.X Fragments of a developer's workflow
### 3.X The special configuration branch
### 3.X The push to origin as backup
### 3.X Branches namespacing or taking care of your branches
#### 3.X Temporary branches

