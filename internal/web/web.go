package web

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

var ErrorMethodNotAllowed = "method Not allowed"

func handleUnhandledEvent() (*events.APIGatewayProxyResponse, error) {
	return apiResponse(http.StatusMethodNotAllowed, ErrorMethodNotAllowed)
}

func handleHelloEvent(req events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	var request HelloRequest
	if err := json.Unmarshal([]byte(req.Body), &request); err != nil {
		return apiResponse(http.StatusBadRequest, ErrorBody{"failed to parse json body"})
	}

	return apiResponse(http.StatusOK, Response{Status: true, Message: fmt.Sprintf("hello %s", req.Body)})
}

func handlePingEvent(req events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	return apiResponse(http.StatusOK, Response{Status: true, Message: "pong"})
}

func HandleRequests(ctx context.Context, e events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	fmt.Println(e.Resource)
	switch e.Resource {
	case "/hello":
		return handleHelloEvent(e)
	case "/ping":
		return handlePingEvent(e)
	default:
		return handleUnhandledEvent()
	}
}
