## Examples

    cody logs # project name inferred
    cody logs PROJECT # project name explicit

## Examples with Output

    $ cody logs
    Showing logs for build demo:ada202f1-6b30-4eb9-8625-7371a9911b7d
    Phase: SUBMITTED Status: SUCCEEDED Duration: 0
    Phase: QUEUED Status: SUCCEEDED Duration: 1
    Phase: PROVISIONING Status: SUCCEEDED Duration: 40
    Phase: DOWNLOAD_SOURCE Status: SUCCEEDED Duration: 0
    Phase: INSTALL Status: SUCCEEDED Duration: 20
    Phase: PRE_BUILD Status: SUCCEEDED Duration: 20
    Phase: BUILD Status: SUCCEEDED Duration: 20
    Phase: POST_BUILD Status: SUCCEEDED Duration: 20
    Phase: UPLOAD_ARTIFACTS Status: SUCCEEDED Duration: 0
    Phase: FINALIZING Status: SUCCEEDED Duration: 2
    Phase: COMPLETED Status:  Duration:
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:06 Waiting for agent ping
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Waiting for DOWNLOAD_SOURCE
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Phase is DOWNLOAD_SOURCE
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 CODEBUILD_SRC_DIR=/codebuild/output/src088335237/src/github.com/tongueroo/cody-demo
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 YAML location is /codebuild/output/src088335237/src/github.com/tongueroo/cody-demo/.cody/buildspec.yml
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Processing environment variables
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Moving to directory /codebuild/output/src088335237/src/github.com/tongueroo/cody-demo
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Registering with agent
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Phases found in YAML: 4
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08  PRE_BUILD: 2 commands
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08  BUILD: 2 commands
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08  POST_BUILD: 2 commands
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08  INSTALL: 2 commands
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Phase complete: DOWNLOAD_SOURCE State: SUCCEEDED
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Phase context status code:  Message:
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Entering phase INSTALL
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Running command pwd
    2019-11-28 05:15:12 UTC /codebuild/output/src088335237/src/github.com/tongueroo/cody-demo
    2019-11-28 05:15:12 UTC
    2019-11-28 05:15:12 UTC [Container] 2019/11/28 05:15:08 Running command .cody/sleep.sh install
    2019-11-28 05:15:12 UTC 0: install
    2019-11-28 05:15:12 UTC Thu Nov 28 05:15:08 UTC 2019
    ...
    19-11-28 05:16:29 UTC [Container] 2019/11/28 05:16:29 Phase complete: POST_BUILD State: SUCCEEDED
    2019-11-28 05:16:29 UTC [Container] 2019/11/28 05:16:29 Phase context status code:  Message:
    $

## Since Option

By default, Cody logs searches only 7 days in the past. This is done for speed. If you have an older build and would like to search further in the past.  You can use the `--since option`.  Example:

    cody logs --since 1m # 1 month ago

The since format is from the [aws-logs gem](https://github.com/tongueroo/aws-logs). Since formats:

* s - seconds
* m - minutes
* h - hours
* d - days
* w - weeks

Since does not support combining the formats. IE: 5m30s.