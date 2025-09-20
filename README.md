# discountex

A web scraper for listing products from Wellcome Hong Kong's website. This application can search for products and display their names, prices, and URLs.

## Features

- Search for products on Wellcome Hong Kong website
- Parse and extract product information (name, price, URL)
- Command-line interface for easy usage
- Built-in error handling

## Usage

### Interactive Mode

Start an interactive Elixir session:

```bash
mix deps.get
iex -S mix
```

Then use the functions directly:

```elixir
# Search for potato chips on page 1
{:ok, products} = Discountex.list_products("potato chip", 1)

# Use the CLI module
Discountex.CLI.main()                    # Default: search for "potato chip"
Discountex.CLI.main(["milk"])            # Search for "milk"
Discountex.CLI.main(["bread", "2"])      # Search for "bread" on page 2
```

### Example Output

```
Searching for 'potato chip' on page 1...
URL: https://www.wellcome.com.hk/zh-hant/search?keyword=potato%20chip&page=1

Found 3 product(s):

1. Lay's Potato Chips Original 130g
   Price: HK$18.90
   URL: https://www.wellcome.com.hk/product/lays-original-130g

2. Pringles Original 110g
   Price: HK$22.50
   URL: https://www.wellcome.com.hk/product/pringles-original-110g

3. Calbee Potato Chips BBQ 55g
   Price: HK$12.90
   URL: https://www.wellcome.com.hk/product/calbee-bbq-55g
```

## Target URL

This application is designed to work with Wellcome Hong Kong's search functionality:
`https://www.wellcome.com.hk/zh-hant/search?keyword=potato%20chip&page=1`

## Implementation

Currently implements a mock version that demonstrates the expected functionality. In a production environment, this would use HTTP clients and HTML parsers to fetch and parse real data from the website.

## Testing

Run the test suite:

```bash
mix test
```

## Dependencies

- Elixir 1.14+
- Erlang/OTP 25+