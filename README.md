# Shopping Cart API

**A fully dockerized Shopping Cart API built with Ruby on Rails.**  
This API allows you to manage a shopping cart, including adding/removing products, updating quantities, and calculating the total price. It's designed to be easy to set up and run using Docker.

---

## Features

- **Product Management**: Add, update, and remove products from the cart.
- **Cart Operations**: 
  - Add items to the cart.
  - Update item quantities.
  - Remove items from the cart.
  - Calculate the total price of the cart.
- **Dockerized**: Fully containerized for easy setup and deployment.
- **Testing**: Comprehensive test suite implemented with RSpec.

---

## Getting Started

### Prerequisites

- Docker installed on your machine.
- Docker Compose installed.

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/VBDomingos/shopping-cart-api.git
   cd shopping-cart-api
   ```
2. **Build and start the containers**:
   ```bash
   docker-compose build
   docker-compose up
   ```
3. **Access the API**:
   The API will be running at http://localhost:3000.

# API Documentation

## API Endpoints

### Cart Operations

- **GET** `/cart`: Retrieve the current cart.

- **POST** `/cart/add_item`: Add a product to the cart.
  - **Parameters**: `product_id`, `quantity`.

- **DELETE** `/cart/:product_id`: Remove a product from the cart.

---

### Product Operations

- **GET** `/products`: List all available products.

- **POST** `/products`: Create a new product.
  - **Parameters**: `name`, `price`.

- **DELETE** `/products/:id`: Delete a product.

