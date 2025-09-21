defmodule DiscountexWeb.ProductsLive do
  @moduledoc """
  LiveView for displaying Wellcome products search results.
  """
  use DiscountexWeb, :live_view

  alias Discountex.WellcomeApi

  @impl true
  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:products, [])
      |> assign(:loading, false)
      |> assign(:search_term, "")
      |> assign(:current_page, 1)
      |> assign(:error, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    search_term = params["search"] || "potato chip"
    page = String.to_integer(params["page"] || "1")
    
    socket = 
      socket
      |> assign(:search_term, search_term)
      |> assign(:current_page, page)
      |> assign(:loading, true)
    
    send(self(), {:search_products, search_term, page})
    
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"search_term" => search_term}}, socket) do
    path = ~p"/products?#{%{search: search_term, page: 1}}"
    {:noreply, push_patch(socket, to: path)}
  end

  @impl true
  def handle_info({:search_products, search_term, page}, socket) do
    case WellcomeApi.search_products(search_term, page) do
      {:ok, products} ->
        socket = 
          socket
          |> assign(:products, products)
          |> assign(:loading, false)
          |> assign(:error, nil)
        
        {:noreply, socket}
      
      {:error, reason} ->
        socket = 
          socket
          |> assign(:products, [])
          |> assign(:loading, false)
          |> assign(:error, "Failed to load products: #{reason}")
        
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div class="mb-8">
        <h1 class="text-3xl font-bold leading-tight tracking-tight text-gray-900 sm:text-4xl">
          Wellcome Products Search
        </h1>
        <p class="mt-2 text-lg text-gray-600">
          Search for grocery products from Wellcome Hong Kong
        </p>
      </div>

      <!-- Search Form -->
      <div class="mb-8">
        <.form for={%{}} as={:search_form} phx-submit="search" class="flex gap-4">
          <div class="flex-1">
            <.input
              type="text"
              name="search_term"
              value={@search_term}
              placeholder="Search products (e.g., potato chip, milk, bread)"
              class="w-full"
            />
          </div>
          <.button type="submit" class="px-6">
            <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            Search
          </.button>
        </.form>
      </div>

      <!-- Loading State -->
      <div :if={@loading} class="flex justify-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-500"></div>
      </div>

      <!-- Error State -->
      <div :if={@error} class="mb-8 p-4 bg-red-50 border border-red-200 rounded-md">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
          <span class="ml-2 text-red-700">{@error}</span>
        </div>
      </div>

      <!-- Products Grid -->
      <div :if={!@loading and @products != []} class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        <div :for={product <- @products} class="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200">
          <!-- Product Image Placeholder -->
          <div class="h-48 bg-gray-200 rounded-t-lg flex items-center justify-center">
            <svg class="h-16 w-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
          
          <div class="p-4">
            <!-- Product Name -->
            <h3 class="text-lg font-semibold text-gray-900 mb-2 line-clamp-2">
              {product.name}
            </h3>
            
            <!-- Brand and Weight -->
            <p class="text-sm text-gray-600 mb-2">
              {product.brand} • {product.weight}
            </p>
            
            <!-- Price Section -->
            <div class="flex items-center justify-between mb-3">
              <div class="flex items-center space-x-2">
                <span class="text-xl font-bold text-orange-600">{product.price}</span>
                <span :if={product.original_price != product.price} class="text-sm text-gray-500 line-through">
                  {product.original_price}
                </span>
              </div>
              <span :if={product.discount_percentage} class="bg-red-100 text-red-800 text-xs font-medium px-2 py-1 rounded">
                -{product.discount_percentage}
              </span>
            </div>
            
            <!-- Promo Tags -->
            <div :if={product.promo_tags != []} class="flex flex-wrap gap-1 mb-3">
              <span :for={tag <- product.promo_tags} class="bg-orange-100 text-orange-800 text-xs font-medium px-2 py-1 rounded">
                {tag}
              </span>
            </div>
            
            <!-- Stock Status -->
            <div class="flex items-center justify-between">
              <span class={[
                "text-xs font-medium px-2 py-1 rounded",
                if(product.in_stock, do: "bg-green-100 text-green-800", else: "bg-red-100 text-red-800")
              ]}>
                {if product.in_stock, do: "In Stock", else: "Out of Stock"}
              </span>
              
              <button class={[
                "px-3 py-1 text-sm font-medium rounded transition-colors",
                if(product.in_stock, 
                  do: "bg-orange-600 text-white hover:bg-orange-700", 
                  else: "bg-gray-300 text-gray-500 cursor-not-allowed"
                )
              ]} disabled={!product.in_stock}>
                Add to Cart
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div :if={!@loading and @products == [] and !@error} class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900">No products found</h3>
        <p class="mt-1 text-sm text-gray-500">Try searching for different keywords.</p>
      </div>

      <!-- Search Info -->
      <div :if={!@loading and @products != []} class="mt-8 text-center text-sm text-gray-600">
        Showing results for "<strong>{@search_term}</strong>" • Page {@current_page}
      </div>
    </div>
    """
  end
end