# git_off
**Purpose:** Maintain that meaningless streak with a git code queue!

**Use:** Similar to git except files or directories you add are put into a queue. Once a day, the queue is checked, and the first item is commited and pushed up to the remote repo

**Install**

1. Clone / download repo
2. `cd` into repo
3. run the install file: `./install.sh`
4. use git_off the same way you would Git: `git_off` *some command*

##Available commands

- `add -A`        add directory
- `add .`         add directory
- `add filename`  add file
- `commit -m`     commit message
- `status`        display current queue
- `rm queue_id`  remove an item from the queue
- `ll`           display last item added to queue'
  
  
## TODO / Current issues:

1. git_off status sometimes removes an item from the queue. The status code needs to be fixed!

2. install.sh can mess up a current queue and delete items. Possibly related to the above error?

3. If your computer is not on when the cron job is scheduled to run, git_off will miss commiting an item for the day. There needs to be some redudant cron logic to check every hour or so that the job actually was run. 
