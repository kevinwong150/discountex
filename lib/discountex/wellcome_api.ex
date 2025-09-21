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
    params = %{
      keyword: keyword,
      page: page
    }
    
    case make_api_request(params) do
      {:ok, response} ->
        products = transform_api_response(response)
        {:ok, products}
      
      {:error, reason} ->
        # Fallback to mock data if API fails for development
        IO.puts("API request failed: #{reason}. Using mock data for development.")
        {:ok, mock_products()}
    end
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

  # HTTP request implementation for the actual Wellcome API
  defp make_api_request(params) do
    payload = build_request_payload(params)
    headers = build_headers()
    
    case Finch.build(:post, @api_base_url, headers, encode_json(payload))
         |> Finch.request(Discountex.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        case decode_json(body) do
          {:ok, response} -> {:ok, response}
          {:error, _} -> {:error, "Invalid JSON response"}
        end
      
      {:ok, %Finch.Response{status: status_code}} ->
        {:error, "API returned status #{status_code}"}
      
      {:error, reason} ->
        {:error, "Network error: #{inspect(reason)}"}
    end
  end

  # JSON encoding/decoding with fallback
  defp encode_json(data) do
    try do
      Jason.encode!(data)
    rescue
      _error ->
        # Fallback if Jason is not available
        "{}"
    end
  end

  defp decode_json(json_string) do
    try do
      Jason.decode(json_string)
    rescue
      _error ->
        # Fallback if Jason is not available
        {:error, "JSON decode failed"}
    end
  end

  defp build_request_payload(params) do
    %{
      "param" => %{
        "businessCode" => 1,
        "categoryType" => 1,
        "erpStoreId" => 642,
        "venderId" => 5,
        "keyword" => params.keyword,
        "pageNum" => to_string(params.page),
        "pageSize" => 20,
        "filterProperties" => [],
        "sortKey" => 0,
        "sortRule" => 0
      },
      "comm" => %{
        "dmTenantId" => 15,
        "venderId" => 5,
        "businessCode" => 1,
        "origin" => 26,
        "superweb-locale" => "zh_HK",
        "storeId" => 642,
        "pickUpStoreId" => "",
        "shipmentType" => 1
      }
    }
  end

  defp build_headers do
    [
      {"Content-Type", "application/json;charset=UTF-8"},
      {"Accept", "*/*"},
      {"Accept-Language", "en-US,en;q=0.9,zh-Hant;q=0.8,zh;q=0.7,ja;q=0.6"},
      {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36"},
      {"Origin", "https://www.wellcome.com.hk"},
      {"Referer", "https://www.wellcome.com.hk/"},
      {"domain-flag", "wellcome"},
      {"DNT", "1"},
      {"Sec-Fetch-Dest", "empty"},
      {"Sec-Fetch-Mode", "cors"},
      {"Sec-Fetch-Site", "same-origin"}
    ]
  end

  defp transform_api_response(response) do
    case response do
      %{"code" => "0000", "data" => %{"wareList" => ware_list}} when is_list(ware_list) ->
        Enum.map(ware_list, &transform_product/1)
      
      %{"code" => "0000", "data" => %{"wareList" => []}} ->
        []
      
      _ ->
        # If API response format is unexpected, return empty list
        []
    end
  end

  defp transform_product(ware) do
    # Extract brand name from the numeric brand ID or use a fallback
    brand_name = get_brand_name(ware["brand"]) || "Unknown Brand"
    
    # Parse price from string to integer (price is in cents)
    price = case ware["warePrice"] do
      price_str when is_binary(price_str) ->
        {price_int, _} = Integer.parse(price_str)
        price_int / 100  # Convert from cents to dollars
      price_int when is_integer(price_int) ->
        price_int / 100
      _ ->
        0.0
    end

    # Extract promotion info if available
    {discount_price, discount_percentage, promo_tags} = extract_promotion_info(ware)

    %{
      id: to_string(ware["wareId"]),
      name: ware["wareName"] || "",
      price: price,
      original_price: price,
      discount_price: discount_price,
      discount_percentage: discount_percentage,
      promo_tags: promo_tags,
      image_url: ware["wareImg"] || "",
      description: ware["wareName"] || "",
      brand: brand_name,
      weight: extract_weight_from_name(ware["wareName"]),
      in_stock: ware["wareStatus"] == 0
    }
  end

  defp extract_promotion_info(ware) do
    promotion_price = case ware["onlinePromotionPrice"] do
      price when is_integer(price) and price > 0 -> price / 100
      _ -> nil
    end

    original_price = case ware["warePrice"] do
      price_str when is_binary(price_str) ->
        {price_int, _} = Integer.parse(price_str)
        price_int / 100
      price_int when is_integer(price_int) ->
        price_int / 100
      _ ->
        0.0
    end

    discount_percentage = if promotion_price && promotion_price < original_price do
      round((original_price - promotion_price) / original_price * 100)
    else
      nil
    end

    # Extract promotion tags from promotionWareVO
    promo_tags = case ware["promotionWareVO"]["promotionInfoList"] do
      promotion_list when is_list(promotion_list) ->
        promotion_list
        |> Enum.map(fn promo -> promo["displayInfo"]["proTag"] end)
        |> Enum.filter(& &1)
      _ ->
        []
    end

    {promotion_price, discount_percentage, promo_tags}
  end

  defp extract_weight_from_name(name) when is_binary(name) do
    # Extract weight from product name (e.g., "55GM", "192G", "105GM")
    case Regex.run(~r/(\d+)G?M?/i, name) do
      [_, weight] -> "#{weight}g"
      _ -> ""
    end
  end

  defp extract_weight_from_name(_), do: ""

  defp get_brand_name(brand_id) do
    # Map common brand IDs to names based on the API response
    brand_map = %{
      24715 => "卡樂B",
      33509 => "樂事",
      28570 => "MEADOWS",
      31702 => "珍珍",
      33369 => "威斯比",
      33256 => "品客",
      25321 => "多樂脆",
      28144 => "RUFFLES",
      59056 => "LAY'S STAX",
      33155 => "利趣"
    }
    
    Map.get(brand_map, brand_id)
  end
end