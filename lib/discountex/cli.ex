defmodule Discountex.CLI do
  @moduledoc """
  Command line interface for Discountex.
  """

  def main(args \\ []) do
    case args do
      [] -> 
        # Default: search for potato chips on page 1 as mentioned in the problem statement
        search_and_display("potato chip", 1)
      [keyword] ->
        search_and_display(keyword, 1)
      [keyword, page] ->
        {page_num, _} = Integer.parse(page)
        search_and_display(keyword, page_num)
      _ ->
        IO.puts("Usage: discountex [keyword] [page]")
        IO.puts("Example: discountex \"potato chip\" 1")
    end
  end

  defp search_and_display(keyword, page) do
    IO.puts("Searching for '#{keyword}' on page #{page}...")
    IO.puts("URL: https://www.wellcome.com.hk/zh-hant/search?keyword=#{URI.encode(keyword)}&page=#{page}")
    IO.puts("")

    case Discountex.list_products(keyword, page) do
      {:ok, products} ->
        display_products(products)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end

  defp display_products([]) do
    IO.puts("No products found.")
  end

  defp display_products(products) do
    IO.puts("Found #{length(products)} product(s):")
    IO.puts("")

    products
    |> Enum.with_index(1)
    |> Enum.each(fn {product, index} ->
      IO.puts("#{index}. #{product.name}")
      IO.puts("   Price: #{product.price}")
      if product.url do
        IO.puts("   URL: #{product.url}")
      end
      IO.puts("")
    end)
  end
end