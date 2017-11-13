vim-syncr
=========
DISLAIMER: I don't know shit about vim script so I will accept PRs if my code is bad.

vim-syncr is a simple vim script for uploading/downloading files to a remote location or deleting files from a remote location using rsync over ssh.

I needed to solve this workflow and its criterias:
1. Local git repository with typical web files (html, php, images, etc)
2. Remote web root
3. Mirror my local environment to the remote web root minus files/directories marked for exclusion (yes "web files", no git folder)

Criterias:
- Must be able to "clean up" remotely by deleting or renaming files that I delete or rename locally
- Authorization and authentication must "Just work" with SSH keys; I want no hassle, no password prompts

I found [vim-hsftp](https://github.com/hesselbom/vim-hsftp) but I couldn't quite get it to work. It did however have excellent configuration loading code, so [vim-syncr](https://github.com/s10g/vim-syncr) is forked from [vim-hsftp](https://github.com/hesselbom/vim-hsftp). All credit goes to hesselbom/vim-hsftp; without it this project would never have been started.

Install:
------
Install like you would any other Vundle compatible plugin.


Usage:
------
Create a filed called .syncr in your project's root directory containing the following configuration, chmod it to 700 and chpwn it for security:
```
    $ cat /Desktop/projects/newproject/.syncr
    remote_host     www-dev.example.com
    remote_user     bob
    remote_path     /home/bob/html/site1/
    project_path    ~/Desktop/projects/site1/
```


### Commands
    :VsUpload
Syncs files and directories with remote

    :VsDelete
Syncs any file or directory deletions with remote

    :VsDownload
Syncs files and directories with remote (grabs foreign new files)


### Mappings
    <leader>vsu
Calls :VsUpload

    <leader>vsdel
Calls :VsDelete

    <leader>vsd
Calls :VsDownload
