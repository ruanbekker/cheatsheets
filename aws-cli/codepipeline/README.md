# AWS CodePipeline CLI

## Export a Pipeline

```
$ aws codepipeline create-pipeline --pipeline my-pipeline --cli-input-json file://pipeline.json
```

## Create Pipeline from JSON

```
$ aws codepipeline create-pipeline --cli-input-json file://pipeline.json
```

## View Pipeline Source

```
$ aws codepipeline get-pipeline --name my-pipeline | jq -r '.pipeline.stages[] | select(.name == "Source") .actions[].configuration.Branch'
```
