# DiscountEx

A web application that scrapes product data from the Wellcome API and displays discounted items in a user-friendly interface.

## Features

- **Product Search**: Search for products using keywords (e.g., "potato chip", "snacks")
- **Item Information Display**: Shows essential product details including:
  - Product name
  - Current price
  - Original price (if available)
  - Promotional tags/offers
  - Brand information
  - Product descriptions
- **Responsive Design**: Clean, modern UI that works on different screen sizes
- **Mock Data Fallback**: Displays sample data when the actual API is not accessible

## Installation

1. Clone the repository:
```bash
git clone https://github.com/kevinwong150/discountex.git
cd discountex
```

2. Install dependencies:
```bash
npm install
```

3. Start the application:
```bash
npm start
```

4. Open your browser and navigate to `http://localhost:3000`

## API Endpoints

### GET /api/search
Searches for products from the Wellcome API.

**Parameters:**
- `keyword` (string): Search term for products
- `page` (number): Page number for pagination (default: 1)

**Example:**
```
GET /api/search?keyword=potato%20chip&page=1
```

**Response:**
```json
{
  "success": true,
  "keyword": "potato chip",
  "page": 1,
  "totalItems": 3,
  "items": [
    {
      "id": "mock1",
      "name": "Lay's Potato Chips Original",
      "price": "HK$12.90",
      "originalPrice": "HK$15.90",
      "promotags": ["20% OFF", "SPECIAL OFFER"],
      "brand": "Lay's",
      "description": "Classic original flavor potato chips"
    }
  ]
}
```

## Usage

1. Enter a product search term in the search box
2. Optionally specify a page number
3. Click "Search" to fetch and display results
4. Browse through the product cards showing prices and promotional offers

## Technical Details

- **Backend**: Node.js with Express
- **Frontend**: Vanilla HTML/CSS/JavaScript
- **HTTP Client**: Axios for API requests
- **Target API**: Wellcome Hong Kong product search API

## Development

The application includes:
- Error handling for API failures
- Mock data for development/testing
- CORS support for cross-origin requests
- Responsive grid layout for product display