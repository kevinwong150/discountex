defmodule Discountex.WellcomeApiTest do
  use ExUnit.Case, async: true

  alias Discountex.WellcomeApi

  describe "search_products/2" do
    test "returns mock products with correct structure" do
      assert {:ok, products} = WellcomeApi.search_products("potato chip", 1)
      
      assert is_list(products)
      assert length(products) > 0
      
      product = List.first(products)
      
      # Verify required fields exist
      assert Map.has_key?(product, :id)
      assert Map.has_key?(product, :name)
      assert Map.has_key?(product, :price)
      assert Map.has_key?(product, :brand)
      assert Map.has_key?(product, :in_stock)
      assert Map.has_key?(product, :promo_tags)
      
      # Verify data types
      assert is_binary(product.id)
      assert is_binary(product.name)
      assert is_binary(product.price)
      assert is_binary(product.brand)
      assert is_boolean(product.in_stock)
      assert is_list(product.promo_tags)
    end

    test "returns products for different search terms" do
      assert {:ok, products1} = WellcomeApi.search_products("potato chip", 1)
      assert {:ok, products2} = WellcomeApi.search_products("milk", 1)
      
      # Should return same mock data regardless of search term (for now)
      assert products1 == products2
    end

    test "handles different page numbers" do
      assert {:ok, products1} = WellcomeApi.search_products("test", 1)
      assert {:ok, products2} = WellcomeApi.search_products("test", 2)
      
      # Should return same mock data regardless of page (for now)
      assert products1 == products2
    end
  end
end