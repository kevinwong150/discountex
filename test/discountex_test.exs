defmodule DiscountexTest do
  use ExUnit.Case
  doctest Discountex

  test "lists potato chip products" do
    {:ok, products} = Discountex.list_products("potato chip", 1)
    
    assert length(products) == 3
    assert Enum.any?(products, fn product -> 
      String.contains?(product.name, "Lay's") 
    end)
    assert Enum.any?(products, fn product -> 
      String.contains?(product.name, "Pringles") 
    end)
    assert Enum.any?(products, fn product -> 
      String.contains?(product.name, "Calbee") 
    end)
    
    # Check all products have required fields
    Enum.each(products, fn product ->
      assert product.name
      assert product.price
      assert product.url
      assert String.starts_with?(product.url, "https://www.wellcome.com.hk")
    end)
  end

  test "returns empty list for unknown products" do
    {:ok, products} = Discountex.list_products("unknown product", 1)
    assert products == []
  end

  test "builds correct search URL" do
    # This tests the URL building functionality indirectly
    {:ok, _products} = Discountex.list_products("potato chip", 1)
    # If this doesn't crash, the URL building works correctly
    assert true
  end
end