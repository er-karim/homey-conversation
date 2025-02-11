# Project Conversation History

A Ruby on Rails application that enables users to track project discussions through comments and status changes. This application demonstrates modern Rails development practices, including Single Table Inheritance (STI), form objects, service objects, and comprehensive testing.

## Overview

The Project Conversation History is designed to maintain a chronological record of project-related communications. Users can contribute in two ways: by leaving comments or by updating the project's status. All interactions are displayed in a unified, reverse-chronological timeline.

## Requirements Analysis

Before implementation, several key questions were addressed to ensure proper understanding of the requirements:

### Project & User Context

- **Q**: Should we implement a full Project model?
- **A**: For this implementation, we assume a single project context.

- **Q**: Is user authentication required?
- **A**: A simple author name field is sufficient; no authentication needed.

### Data & Domain Models

- **Q**: How should we structure conversation events?
- **A**: Using Single Table Inheritance with a base ConversationEvent model and two subclasses: Comment and StatusChange.

- **Q**: What are the valid project statuses?
- **A**: Predefined statuses: Draft, In Review, Approved, and Rejected.

### UI/UX Considerations

- **Q**: How should the conversation history be displayed?
- **A**: Reverse chronological order with paginated results.

- **Q**: What styling approach should be used?
- **A**: Tailwind CSS for modern, responsive design.

## Tech Stack

- Ruby 3.3.1
- Rails 8.0.1
- PostgreSQL
- Tailwind CSS
- ViewComponent
- Hotwire (Turbo + Stimulus)
- RSpec for testing

## Key Features

- Comment creation with author and content
- Project status updates with predefined states
- Paginated conversation history
- Real-time updates using Hotwire
- Responsive design with Tailwind CSS

## Architecture Highlights

### Models

- **Single Table Inheritance (STI)** for efficient event handling
- Base ConversationEvent model with Comment and StatusChange subclasses
- Comprehensive validation rules

### Form Objects

- Separation of form logic from models
- Custom validation messages
- Proper error handling

### Service Objects

- Encapsulated business logic
- Transaction management
- Robust error handling

### Components

- Reusable ViewComponents for UI elements
- Clear separation of concerns
- Enhanced maintainability

## Installation

1. Clone the repository and access it:

   ```bash
   cd path/to/project-conversation
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Setup database:

   ```bash
   rails db:create db:migrate
   ```

4. Start the server:
   ```bash
   ./bin/dev
   ```

## Running Tests

Execute the test suite:

```bash
bundle exec rspec
```

## Best Practices Demonstrated

1. **Domain-Driven Design**

   - Clear separation of concerns
   - Form objects for complex form handling
   - Service objects for business logic

2. **Testing**

   - Comprehensive test coverage
   - Unit, integration, and system tests
   - Factory-based test data

3. **Modern Rails Patterns**

   - Single Table Inheritance
   - ViewComponents for reusable UI
   - Hotwire for real-time updates

4. **Code Quality**

   - Consistent code style
   - Clear documentation
   - Proper error handling

5. **UI/UX**
   - Responsive design
   - Real-time updates
   - Clear feedback messages

## Project Structure

```
app/
├── components/        # ViewComponents for UI
├── controllers/       # Application controllers
├── forms/             # Form objects
├── models/            # Domain models
├── services/          # Service objects
└── views/             # View templates
```
