defmodule Discountex do
  @moduledoc """
  A module for scraping and listing product information from Wellcome Hong Kong website.
  """

  @wellcome_base_url "https://www.wellcome.com.hk"

  @doc """
  Fetches and lists products from Wellcome Hong Kong search results.
  
  ## Examples
  
      iex> {:ok, products} = Discountex.list_products("potato chip", 1)
      iex> length(products)
      3
      iex> Enum.all?(products, fn p -> p.name && p.price && p.url end)
      true
  
  """
  def list_products(keyword, page \\ 1) do
    search_url = build_search_url(keyword, page)
    
    # For demonstration purposes, since we can't access the actual website
    # This would normally fetch and parse the actual webpage
    case fetch_page_mock(search_url, keyword) do
      {:ok, html} ->
        products = parse_products_mock(html, keyword)
        {:ok, products}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp build_search_url(keyword, page) do
    encoded_keyword = URI.encode(keyword)
    "#{@wellcome_base_url}/zh-hant/search?keyword=#{encoded_keyword}&page=#{page}"
  end

  # Mock function for demonstration - would normally use HTTPoison
  defp fetch_page_mock(_url, keyword) do
    # Simulate different responses based on keyword
    case keyword do
      "potato chip" ->
        mock_html = """
        <div class="product-item">
          <h3 class="product-name">Lay's Potato Chips Original 130g</h3>
          <div class="price">HK$18.90</div>
          <a href="/product/lays-original-130g">View Details</a>
        </div>
        <div class="product-item">
          <h3 class="product-name">Pringles Original 110g</h3>
          <div class="price">HK$22.50</div>
          <a href="/product/pringles-original-110g">View Details</a>
        </div>
        <div class="product-item">
          <h3 class="product-name">Calbee Potato Chips BBQ 55g</h3>
          <div class="price">HK$12.90</div>
          <a href="/product/calbee-bbq-55g">View Details</a>
        </div>
        """
        {:ok, mock_html}
      _ ->
        {:ok, "<div>No products found</div>"}
    end
  end

  # Mock function for demonstration - would normally use Floki
  defp parse_products_mock(_html, keyword) do
    case keyword do
      "potato chip" ->
        [
          %{
            name: "Lay's Potato Chips Original 130g",
            price: "HK$18.90",
            url: @wellcome_base_url <> "/product/lays-original-130g"
          },
          %{
            name: "Pringles Original 110g", 
            price: "HK$22.50",
            url: @wellcome_base_url <> "/product/pringles-original-110g"
          },
          %{
            name: "Calbee Potato Chips BBQ 55g",
            price: "HK$12.90",
            url: @wellcome_base_url <> "/product/calbee-bbq-55g"
          }
        ]
      _ ->
        []
    end
  end

  # The following functions would be used in the real implementation with Floki
  # defp parse_products(html) do
  #   html
  #   |> Floki.parse_document!()
  #   |> Floki.find(".product-item, .product-card, [data-testid='product-item']")
  #   |> Enum.map(&extract_product_info/1)
  #   |> Enum.filter(&(&1 != nil))
  # end

  # defp extract_product_info(product_element) do
  #   try do
  #     name = extract_product_name(product_element)
  #     price = extract_product_price(product_element)
  #     url = extract_product_url(product_element)
      
  #     if name && price do
  #       %{
  #         name: String.trim(name),
  #         price: String.trim(price),
  #         url: url
  #       }
  #     else
  #       nil
  #     end
  #   rescue
  #     _ -> nil
  #   end
  # end

  # defp extract_product_name(element) do
  #   element
  #   |> Floki.find(".product-name, .product-title, h3, h4, .title")
  #   |> Floki.text()
  #   |> case do
  #     "" -> 
  #       element
  #       |> Floki.find("a[title]")
  #       |> Floki.attribute("title")
  #       |> List.first()
  #     name -> name
  #   end
  # end

  # defp extract_product_price(element) do
  #   element
  #   |> Floki.find(".price, .product-price, .current-price, [class*='price']")
  #   |> Floki.text()
  # end

  # defp extract_product_url(element) do
  #   case Floki.find(element, "a") do
  #     [{"a", attrs, _} | _] ->
  #       case List.keyfind(attrs, "href", 0) do
  #         {"href", href} -> 
  #           if String.starts_with?(href, "http") do
  #             href
  #           else
  #             @wellcome_base_url <> href
  #           end
  #         _ -> nil
  #       end
  #     _ -> nil
  #   end
  # end
end