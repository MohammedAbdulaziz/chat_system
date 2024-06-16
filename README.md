# Chat System

This is a scalable chat system built with Ruby on Rails, Redis, RabbitMQ, MySQL, and Elasticsearch. The system supports applications, chats, and messages, with asynchronous processing using RabbitMQ and Sneakers.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Docker
- Docker Compose

### Clone the Repository

```bash
git clone https://github.com/MohammedAbdulaziz/chat_system.git
cd chat_system
```

### Docker Setup

1. **Build and Start Services**:

    To run the application in the development environment, use the following command:

    ```bash
    docker-compose up --build
    ```

    This command builds the images and starts the containers. By default, the Rails application runs in the development environment.

2. **Run Database Migrations**:

    After starting the services, set up the database for the development environment:

    ```bash
    docker-compose run web rake db:create db:migrate
    ```

### Access the Application

- **Rails Application**: The application will be available at [http://localhost:3000](http://localhost:3000).
- **RabbitMQ Management Console**: Access the RabbitMQ management console at [http://localhost:15672](http://localhost:15672) (username: guest, password: guest).
- **Elasticsearch**: Elasticsearch will be running on [http://localhost:9200](http://localhost:9200).

## API Endpoints

### Applications

- **Create Application**:

    ```http
    POST /applications
    Content-Type: application/json
    {
      "application": {
        "name": "Your Application Name"
      }
    }
    ```

- **Update Application**:

    ```http
    PUT /applications/:application_token
    Content-Type: application/json
    {
      "application": {
        "name": "Updated Application Name"
      }
    }
    ```

- **Get Application**:

    ```http
    GET /applications/:application_token
    ```

### Chats

- **Create Chat**:

    ```http
    POST /applications/:application_token/chats
    ```

- **Update Chat**:

    ```http
    PUT /applications/:application_token/chats/:chat_number
    Content-Type: application/json
    {
      "chat": {
        "number": 1
      }
    }
    ```

- **Get Chat**:

    ```http
    GET /applications/:application_token/chats/:chat_number
    ```

### Messages

- **Create Message**:

    ```http
    POST /applications/:application_token/chats/:chat_number/messages
    Content-Type: application/json
    {
      "message": {
        "body": "Your message content"
      }
    }
    ```

- **Update Message**:

    ```http
    PUT /applications/:application_token/chats/:chat_number/messages/:message_number
    Content-Type: application/json
    {
      "message": {
        "body": "Updated message content"
      }
    }
    ```

- **Get Message**:

    ```http
    GET /applications/:application_token/chats/:chat_number/messages/:message_number
    ```

- **Search Messages**:

    ```http
    GET /applications/:application_token/chats/:chat_number/messages/search?query=search_term
    ```

## Background Jobs

The application uses Sneakers and RabbitMQ to handle background jobs for creating chats and messages.

### Create Chat Worker

The `CreateChatWorker` listens to the `create_chat` queue and creates a chat for the specified application.

### Create Message Worker

The `CreateMessageWorker` listens to the `create_message` queue and creates a message for the specified chat.

## Running Tests

To prepare and run tests, follow these steps:

1. **Set Rails Environment to Test**:

    Before running tests, create and migrate the test database with the following command:

    ```bash
    docker-compose exec -e RAILS_ENV=test web rails db:create db:migrate
    ```

    This command creates and migrates the database in the test environment.

2. **Execute Tests**:

    Now, run the tests with the following command:

    ```bash
    docker-compose exec -e RAILS_ENV=test web bundle exec rspec
    ```

    This command executes the tests in the test environment, ensuring that your development database is not affected by test data.