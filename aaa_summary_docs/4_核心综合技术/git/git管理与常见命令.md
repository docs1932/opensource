# 1.常见的代码管理模式
## 1.1 fork-merge 模式
即: 代码主仓是A, 各个开发者分别基于主仓A开始fork自己的仓库, 如:forkA1, forkA2
开发时,
>> 先将代码push到自己的仓库forkA1,
>> 然后从主仓A开始pull代码到本地, 再次push到自己的仓库forkA1,
>> 进入自己的仓库forkA1, 发起 pull request 请求

## 1.2 分支开发模式
即: 代码主仓是A,
>> 每次版本开发时, 先基于主分支master/develop 拉出分支1,
>> 然后各个人员基于分支1开发并提交代码
>> 分支1稳定后, 可向develop分支发起 pull request 请求进行合并

# 2.git 分支管理
## 2.1 master 分支(长期分支)
是所有分支的上游, 始终与prd环境最新代码保持一致.只能从其他分支合并, 不能直接修改代码.
可基于master分支拉出develop和hotfix分支, 可接受来自develop和hotfix分支的合并请求.
## 2.2 develop 分支(长期分支)
规划一个新的发布版本, 不能直接在此分支上修改. 可以接受来自 feature 和 hotfix 分支的合并请求.
可以基于 develop 分支拉出 feature 或者 hotfix 分支
## 2.3 feature 分支(短期分支)
主要用来开发一个新的功能, 一旦开发完成, 便合并回 develop 分支, 如月度版本迭代时, 每个月都可以啦一个 feature 分支.
## 2.4 hotfix 分支(短期分支)
主要用于修复生产上的bug而拉的分支, 解决后, 再将代码合并回 develop 和 master 分支.

# 3.下载安装 git
https://git-scm.com/install/

# 4.配置 git
```
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
git config --global core.editor "nano"  # 例如使用 nano，你也可以使用 vim 或其他你喜欢的编辑器
```

# 5.常用命令
## 5.1 基础命令
```
# 1.初始化仓库
在你的项目目录中，初始化一个新的 Git 仓库：
cd 你的项目目录
git init

# 2.添加当前目录下的所有文件到暂存区
git add .

# 3. 提交修改
git commit -m "jira-123 Add one update button"

# 4.配置远程仓库
git remote add origin "https://github.com/aaa/bbb/ccc.git"

# 5.推送到远程仓库
git push -u origin develop
```

## 5.2 分支管理
```
# 1.创建并切换到新的分支
git checkout -b 新分支名

# 2.推送新分支到远程仓库
git push -u origin 新分支名

# 3.拉取和合并分支
git pull origin master  # 拉取并合并 master 分支的最新更改到当前分支（或使用你的分支名）
```