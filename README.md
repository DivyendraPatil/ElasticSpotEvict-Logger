# ElasticSpotEvict-Logger
Lambda for Logging Spot Instance Evictions to Elasticsearch

This is a Golang code snippet that provides a lambda function that logs spot instance evictions to Elasticsearch. Amazon sends a 2-minute termination notice before a spot instance is taken away. This lambda function provides visibility into the logs for the same by logging the event details to Elasticsearch.

![img](https://github.com/DivyendraPatil/ElasticSpotEvict-Logger/blob/main/log_img.png?raw=true)

## Usage

This code can be used as a standalone lambda function or integrated into an existing AWS infrastructure.

Before using this code, please ensure that you have the necessary permissions to create a lambda function and to access Elasticsearch.

## Configuration

This lambda function requires the following configuration:

- AWS credentials with permissions to create and run a lambda function
- Access to an Elasticsearch cluster with the necessary permissions to create and update indexes.

In addition, the following parameters need to be defined in the code:

- `secopsEsUrl`: The URL for the Elasticsearch instance.
- `esIndex`: The name of the Elasticsearch index to be created.
The Elasticsearch instance URL and the index name can be modified as required.

### lambda.tf

- Make sure to update the lambda.tf file and add all the necessary config mainly for `security_group_ids` and `subnet_ids`.

This code also assumes that the AWS credentials are stored as secure string parameters in the AWS SSM Parameter Store. The code retrieves the credentials from SSM during runtime.