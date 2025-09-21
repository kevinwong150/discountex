defmodule DiscountexWeb.ProductsLiveTest do
  use DiscountexWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders products page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/products")
    
    assert html =~ "Wellcome Products Search"
    assert html =~ "Search for grocery products from Wellcome Hong Kong"
    assert html =~ "Search products"
  end

  test "loads products with default search term", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/products")
    
    # Wait for products to load
    assert render(view) =~ "Lay's Original Potato Chips"
    assert render(view) =~ "$18.90"
    assert render(view) =~ "SALE"
  end

  test "performs search with custom term", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/products")
    
    # Perform search
    view
    |> form(".search_form", search_form: %{search_term: "chips"})
    |> render_submit()
    
    # Should update URL with search parameter
    assert_patch(view, "/products?search=chips&page=1")
  end

  test "handles search parameters in URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/products?search=snacks&page=1")
    
    # Should display search term in input
    assert render(view) =~ "value=\"snacks\""
    
    # Should show search results info
    assert render(view) =~ "Showing results for \"snacks\""
  end
end