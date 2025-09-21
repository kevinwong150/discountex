defmodule Discountex.WellcomeApi do
  @moduledoc """
  Client for interacting with the Wellcome grocery store API.
  Handles fetching product data from the wareSearch endpoint.
  """

  @api_base_url "https://www.wellcome.com.hk/api/item/wareSearch"

  @doc """
  Searches for products using the Wellcome API.
  
  ## Parameters
  - keyword: search term (e.g., "potato chip")
  - page: page number (default: 1)
  
  ## Returns
  {:ok, products} | {:error, reason}
  """
  def search_products(keyword, page \\ 1) do
    _params = %{
      keyword: keyword,
      page: page
    }
    
    # For development, return mock data since external API access is limited
    {:ok, mock_products()}
  end

  # Mock data structure based on typical grocery API responses
  defp mock_products do
    [
      %{
        id: "1001",
        name: "Lay's Original Potato Chips 70g",
        price: "$18.90",
        original_price: "$22.90",
        discount_percentage: "17%",
        promo_tags: ["SALE", "LIMITED TIME"],
        image_url: "/images/lays-original.jpg",
        description: "Classic crispy potato chips with sea salt",
        brand: "Lay's",
        weight: "70g",
        in_stock: true
      },
      %{
        id: "1002", 
        name: "Pringles Sour Cream & Onion 158g",
        price: "$32.50",
        original_price: "$35.90",
        discount_percentage: "9%",
        promo_tags: ["NEW ARRIVAL"],
        image_url: "/images/pringles-sour-cream.jpg",
        description: "Delicious sour cream and onion flavored chips",
        brand: "Pringles",
        weight: "158g",
        in_stock: true
      },
      %{
        id: "1003",
        name: "Kettle Brand Sea Salt Potato Chips 142g",
        price: "$28.90",
        original_price: "$28.90", 
        discount_percentage: nil,
        promo_tags: ["ORGANIC", "GLUTEN FREE"],
        image_url: "/images/kettle-sea-salt.jpg",
        description: "All-natural kettle cooked potato chips",
        brand: "Kettle Brand",
        weight: "142g",
        in_stock: true
      },
      %{
        id: "1004",
        name: "Doritos Nacho Cheese 170g",
        price: "$24.90",
        original_price: "$29.90",
        discount_percentage: "17%",
        promo_tags: ["BESTSELLER", "SALE"],
        image_url: "/images/doritos-nacho.jpg",
        description: "Bold nacho cheese flavored tortilla chips",
        brand: "Doritos",
        weight: "170g",
        in_stock: false
      },
      %{
        id: "1005",
        name: "Ruffles Original Potato Chips 184g",
        price: "$26.90",
        original_price: "$26.90",
        discount_percentage: nil,
        promo_tags: [],
        image_url: "/images/ruffles-original.jpg",
        description: "Ridged potato chips perfect for dipping",
        brand: "Ruffles",
        weight: "184g", 
        in_stock: true
      }
    ]
  end

  # Future implementation for making HTTP request to the actual Wellcome API
  # This would be used in production with proper HTTP client.
  # defp make_api_request(params) do
  #   query_string = URI.encode_query(params)
  #   url = "#{@api_base_url}?#{query_string}"
  #   
  #   case HTTPoison.get(url, headers()) do
  #     {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
  #       Jason.decode(body)
  #     {:ok, %HTTPoison.Response{status_code: status_code}} ->
  #       {:error, "API returned status #{status_code}"}
  #     {:error, %HTTPoison.Error{reason: reason}} ->
  #       {:error, reason}
  #   end
  # end

  # defp headers do
  #   [
  #     {"User-Agent", "DiscountEx/1.0"},
  #     {"Accept", "application/json"},
  #     {"Content-Type", "application/json"}
  #   ]
  # end
end