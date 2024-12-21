# Tips on this repository

## How to run aws-nuke command

```
At first, download aws-nuke command.
wget -c https://github.com/rebuy-de/aws-nuke/releases/download/v2.25.0/aws-nuke-v2.25.0-linux-amd64.tar.gz -O - | tar -xz -C $HOME

At second, run aws-nuke command.
./aws-nuke-v2.25.0-linux-amd64 --config nuke-config.yml

At third, run aws-nuke command with --no-dry-run option.
./aws-nuke-v2.25.0-linux-amd64 --config nuke-config.yml --no-dry-run
```
