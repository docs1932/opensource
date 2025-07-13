# 1.下载安装
https://www.rust-lang.org/
```
https://www.rust-lang.org/learn/get-started

根据官网
1.下载安装 vs c++ build tools
记得勾选：使用 C++ 的桌面开发，右侧菜单默认勾选的即可
2.下载安装  rust windows 64 bit
默认安装到了 C:\Users\{your username}\.cargo\bin
3.将上述安装路径配置到 PATH 环境变量
4.打开 cmd 输入：
验证 rust 的编译工具 rustc 是否安装成功
rustc --version
验证 rust 的包管理工具 cargo 是否安装成功
cargo --version
```

## 1.1 在 VS Code 中安装使用 rust
```
在 VS Code 中安装 rust 插件
rust-analyzer
rust
```

## 1.2 常用命令
```
1.创建一个新的工程
cargo new hello-rust
2.build your project with 
cargo build
3.run your project with 
cargo run
4.test your project with 
cargo test
5.build documentation for your project with 
cargo doc
6.publish a library to crates.io with 
cargo publish
7.添加依赖
cargo add <dependency>
```

## 1.3 debug rust 程序 
https://www.bilibili.com/opus/1076138480177774597
```
1.安装 VS Code 插件: 
rust-analyzer
CodeLLDB (这个需要下载一段时间)
2.build 一下程序
cargo build
3.在 .vscode文件夹下创建 launch.json 文件

{
  "type": "lldb",
  "request": "launch",
  "program": "${workspaceFolder}/target/debug/hello-rust.exe",
  "args": [],
  "cwd": "${workspaceFolder}"
}

或者

{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb", // 使用 lldb 调试器
      "name": "debug",
      "request": "launch",
      "program": "${workspaceFolder}/${relativeFileDirname}/../target/debug/hello-rust.exe",
      "args": [],
      "cwd": "${workspaceFolder}",
      "stopOnEntry": false, // 程序是否在入口出暂停
      "internalConsoleOptions": "openOnSessionStart", // 打开调试控制台
      "sourceLanguages": ["rust"] // 指定调试语言为 rust
    }
  ]
}

```