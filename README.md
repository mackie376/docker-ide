# docker-ide

自分が普段使用する開発ツール類を Docker コンテナ内で使用するための、Docker イメージ作成環境一式です。

IDE と名付けてますが、実際にはエディタとしての [Neovim](https://github.com/neovim/neovim) と、シェル環境として [Zsh](https://www.zsh.org) を使用するだけの単純なものです。使用用途としては TypeScript での開発がメインなので、例えば Python の開発を行うときなどは別途パッケージを追加する必要があります。これについては、必要となったタイミングで拡張していきたいと思います。

## 入っているツール

### ベースイメージ

- debian:bullseye-slim

### GitHub から取得するもの

- [Neovim](https://github.com/neovim/neovim) (0.8.1)
- [GitHub CLI](https://cli.github.com) (2.20.2)
- [bat](https://github.com/sharkdp/bat) (0.22.1)
- [fd](https://github.com/sharkdp/fd) (8.5.2)
- [exa](https://github.com/ogham/exa) (0.10.1)
- [fzf](https://github.com/junegunn/fzf) (0.35.0)
- [Lazygit](https://github.com/jesseduffield/lazygit) (0.35)
- [RipGrep](https://github.com/BurntSushi/ripgrep) (13.0.0)
- [ASDF](https://github.com/asdf-vm/asdf) (0.10.2)

### apt で取得するもの

- g++
- git
- git-lfs
- less
- make
- openssh-client
- rsync
- unzip
- wget
- zsh

## 使い方

```sh
git clone https://github.com/mackie376/docker-ide <project-root>

cd <project-root>

dokcer build -t ide:latest .

docker run -it --rm --name <container-name> ide:latest
```

これで、ZSH が起動した状態になります。

Neovim が [Node](https://nodejs.org/en/) を必要とするので、.zprofile 内で ASDF を使って Node と Yarn をインストールしています。何もしなければ v18.12.1 がインストールされますが、Node のバージョンを指定したい場合は、環境変数 NODE_VER にバージョン番号を指定して起動することが出来ます。

同様に、起動時に GitHub からリポジトリを取得したい場合は、GITHUB_REPO_URL にアドレスを設定することで project-root ディレクトリにリポジトリをクローンします。

```sh
docker run -it --rm --name <container-name> -e NODE_VER=19.0.1 -e GITHUB_REPO_URL=https://github.com/mackie376/docker-ide ide:latest
```

## 最後に

完全に自分専用の開発環境なので、他の方がこれをそのまま使用するケースはほとんど無いと思いますが、何かの参考になればと思い、公開リポジトリとして置いておきます。
