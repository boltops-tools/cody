## Create CodeBuild Project

To create the CodeBuild project via CloudFormation run:

    cody deploy demo

This creates the CodeBuild project as well as the necessary IAM role.

## Start Build

To start a build:

    cody start demo

You can also start a build with a specific branch. Remember to `git push` your branch.

    cody start demo -b mybranch
