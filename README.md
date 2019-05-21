# k

`k` is a script to repeatedly run a command on file changes.

`k` stands for **k**eep it running.

# Install

```sh
curl https://raw.githubusercontent.com/seanlerner/k/master/k > /usr/local/bin/k && chmod +x /usr/local/bin/k
```

# Prerequisites

`k` requires [entr](http://eradman.com/entrproject/), [ag](https://github.com/ggreer/the_silver_searcher) and an increased `maxfiles` limit.

Instructions are provided on how to install and set these up when attempting to use `k` for the first time.

# How to use

```sh
k <your command>
```

`Control-C` once will stop and restart the current command.

`Control-C` twice quickly will stop running `k` completely.

# What `k` does

`k` does a few things out of the box. It:

- repeatedly runs a command each time a file changes within the current directory or a subdirectory.
- clears the screen and prints the name of the command at the top before executing it.
- continues to run even if a file is deleted or added to the current directory / subdirectory.

# Where `k` is useful

`k` is useful when you want to run a command over and over again.

### Test failures

For example, if a test is failing using Ruby and minitest, the message will look like so:

```plain
E

Error:
YourTest#test_your_test:
RuntimeError:
    test/test_your_test:6:in `block in <class:YourTest>'

bin/rails test test/test_your_test.rb:5
```

You could then issue the command:

```sh
k bin/rails test test/test_your_test.rb:5
```

and continue to work on your code until the test passes.

### Simple program output

If you're learning a new programming language or doing a 'code challenge' type of test, you could use:

```sh
k ruby my_program.rb
```

to display the results of your program every time you save it.

### Linting

The shell script linter [ShellCheck](https://github.com/koalaman/shellcheck) was used to lint `k`.

In this case, the command was:

```sh
k shellcheck k
```

# How it works

`k` uses [entr](http://eradman.com/entrproject/) and [ag](https://github.com/ggreer/the_silver_searcher) under the hood.

It's possible to achieve a similar effect by using `ag -l | entr -cd <your command>`. However, this script does a few extra things to make the experience a little more pleasant (see [What `k` does](#what-k-does)).
