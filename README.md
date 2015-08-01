# git_off
Maintain that meaningless streak with a git code queue!

Available commands
  add -A        add directory
  add .         add directory
  add filename  add file

  commit -m     commit message

  status        display current queue

  -rm queue_id  remove an item from the queue
  -ll           display last item added to queue'
  
  
Current issues:

git_off status sometimes removes an item from the queue. The status code needs to be fixed!

install.sh can mess up a current queue and delete items. Possibly related to the above error?
