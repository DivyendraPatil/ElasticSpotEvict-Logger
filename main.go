package main

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"
	"github.com/elastic/go-elasticsearch/v8"
	"log"
	"strings"
	"time"
)

type spotEventRecord struct {
	EventVersion    string       `json:"version"`
	EventId         string       `json:"id"`
	EventDetailType string       `json:"detail-type"`
	EventSource     string       `json:"source"`
	Account         string       `json:"account"`
	EventTime       time.Time    `json:"time"`
	AwsRegion       string       `json:"region"`
	Resources       []string     `json:"resources"`
	EventDetails    eventDetails `json:"detail"`
}

type eventDetails struct {
	InstanceID     string `json:"instance-id"`
	InstanceAction string `json:"instance-action"`
}

var secopsEsUrl = "http://secopsEsUrl:80"
var day = time.Now().Local().Format("2006-01-02")
var esIndex = fmt.Sprintf("spot-events-%s", day)

func main() {
	lambda.Start(HandleLambdaEvent)
}

func HandleLambdaEvent(ctx context.Context, eventInfo spotEventRecord) {

	// get credential from ssm
	mySession := session.Must(session.NewSession())
	svc := ssm.New(mySession, aws.NewConfig().WithRegion("us-east-1"))
	sessionInput := ssm.GetParameterInput{}
	sessionInput.SetName("tf-spotevictioneventLambda-username")
	usernameOutput, err := svc.GetParameter(&sessionInput)
	if err != nil {
		log.Fatalf("Error getting username from SSM: %s", err)
	}
	username := *(usernameOutput.Parameter).Value

	sessionInput.SetName("tf-spotevictioneventLambda-password")
	passwordOutput, err := svc.GetParameter(&sessionInput)
	if err != nil {
		log.Fatalf("Error getting password from SSM: %s", err)
	}
	password := *(passwordOutput.Parameter).Value

	cfg := elasticsearch.Config{
		// ...
		Username: username,
		Password: password,
		Addresses: []string{
			secopsEsUrl,
		},
	}
	es, err := elasticsearch.NewClient(cfg)
	if err != nil {
		log.Fatalf("Error creating the client: %s", err)
	}

	// create index content
	dataJSON, err := json.Marshal(eventInfo)
	if err != nil {
		log.Fatalf("Error from converting event info to JSON: %s", err)
	}
	js := string(dataJSON)

	index, err := es.Index(esIndex, strings.NewReader(js), es.Index.WithPretty(), es.Index.WithContext(ctx))
	if err != nil {
		log.Fatalf("Error occurs when creating index: %s", err)
	}
	fmt.Printf(index.String())
}
