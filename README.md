# Clone all repos from GitHub org

Usage:

```
docker run -e GITHUB_TOKEN=<PAT> -e GITHUB_ORG=<ORG> -v <PATH>:/git -v ~/.ssh:/root/.ssh --rm -it github-clone-all
```
