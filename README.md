# git_off
**Purpose:** Maintain that meaningless streak with a git code queue!

**Use:** Similar to git except files or directories you add are put into a queue. Once a day, the queue is checked, and the first item is commited and pushed up to the remote repo

##Available commands

- add -A        add directory
- add .         add directory
- add filename  add file
- commit -m     commit message
- status        display current queue
- rm queue_id  remove an item from the queue
- ll           display last item added to queue'
  
  
##Current issues:

1. git_off status sometimes removes an item from the queue. The status code needs to be fixed!

2. install.sh can mess up a current queue and delete items. Possibly related to the above error?
