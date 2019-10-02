---
title: Contributing
---

Hi there! Interested in contributing to CodeBuild? We'd love your help. CodeBuild is an open source project, built one contribution at a time by users like you.

## Where to get help or report a problem

See [the support guidelines]({% link support.md %})

## Ways to contribute

Whether you're a developer, an infrastructure engineer, or just an enthusiast, there are lots of ways to contribute. Here are a few ideas:

* [Install CodeBuild on your computer](https://https://cody.run.com/docs/install/) and kick the tires. Does it work? Does it do what you'd expect? If not, [open an issue](https://github.com/tongueroo/cody/issues/new/choose) and let us know.
* Comment on some of the project's [open issues](https://github.com/tongueroo/cody/issues). Have you experienced the same problem? Know a workaround? Do you have a suggestion for how the feature could be better?
* Read through [the documentation](https://https://cody.run.com/docs/), and click the "improve this page" button, any time you see something confusing or have a suggestion for something that could be improved.
* Browse through the [CodeBuild Community forum](https://community.https://cody.run.com), and lend a hand answering questions. There's a good chance you've already experienced what another user is experiencing.
* Find [an open issue](https://github.com/tongueroo/cody/issues) (especially [those labeled `help wanted`](https://github.com/tongueroo/cody/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)), and submit a proposed fix. If it's your first pull request, we promise we won't bite and are glad to answer any questions.
* Help evaluate [open pull requests](https://github.com/tongueroo/cody/pulls), by testing the changes locally and reviewing what's proposed.

## Submitting a pull request

### Pull requests generally

* The smaller the proposed change, the better. If you'd like to propose two unrelated changes, submit two pull requests.

* The more information, the better. Make judicious use of the pull request body. Describe what changes were made, why you made them, and what impact they will have for users.

* If this is your first pull request, it may help to [understand GitHub Flow](https://guides.github.com/introduction/flow/).

* If you're submitting a code contribution, be sure to read the [code contributions](#code-contributions) section below.

### Submitting a pull request via github.com

Many small changes can be made entirely through the github.com web interface.

1. Navigate to the file within [tongueroo/cody](https://github.com/tongueroo/cody) that you'd like to edit.
2. Click the pencil icon in the top right corner to edit the file.
3. Make your proposed changes.
4. Click "Propose file change."
5. Click "Create pull request."
6. Add a descriptive title and detailed description for your proposed change. The more information, the better.
7. Click "Create pull request."

That's it! You'll be automatically subscribed to receive updates as others review your proposed change and provide feedback.

### Submitting a pull request via Git command line

1. Fork the project by clicking "Fork" in the top right corner of [tongueroo/cody](https://github.com/tongueroo/cody).
2. Clone the repository locally `git clone https://github.com/<your-username>/codebuild`.
3. Fetch submodules `git submodule init && git submodule update`.
4. Create a new, descriptively named branch to contain your change ( `git checkout -b my-awesome-feature` ).
5. Hack away, add tests. Not necessarily in that order.
6. Make sure everything still passes by running `bundle exec rspec` (see [the tests section](#running-tests-locally) below)
7. Push the branch up ( `git push origin my-awesome-feature` ).
8. Create a pull request by visiting `https://github.com/<your-username>/codebuild` and following the instructions at the top of the screen.

## Proposing updates to the documentation

We want the CodeBuild documentation to be the best it can be. We've open-sourced our docs and we welcome any pull requests if you find it lacking.

### How to submit changes

You can find the documentation for [https://cody.run.com](http://https://cody.run.com) in the [docs](https://github.com/tongueroo/cody/tree/master/docs) directory. See the section above, [submitting a pull request](#submitting-a-pull-request) for information on how to propose a change.

One gotcha, all pull requests should be directed at the `master` branch (the default branch).

## Code Contributions

Interesting in submitting a pull request? Awesome. Read on. There are a few common gotchas that we'd love to help you avoid.

### Tests and documentation

Any time you propose a code change, you should also include updates to the documentation and tests within the same pull request.

#### Documentation

If your contribution changes any CodeBuild behavior, make sure to update the documentation. Documentation lives in the `docs` folder.  It's a Jekyll site and can be started with `cd docs && bin/web`. If the docs are missing information, please feel free to add it in. Great docs make a great project. Include changes to the documentation within your pull request, and once merged, `https://cody.run.com` will be updated.

#### Tests

* If you're creating a small fix or patch to an existing feature, a simple test is more than enough. You can usually copy/paste from an existing example in the `specs` folder.

### Code contributions generally

* Don't bump the Gem version in your pull request (if you don't know what that means, you probably didn't).

## Running tests

### Test Dependencies

To run the test suite by running the following command:

    bundle exec rspec

## Thank You

Thanks! Hacking on CodeBuild should be fun. If you find any of this hard to figure out, let us know so we can improve our process or documentation!