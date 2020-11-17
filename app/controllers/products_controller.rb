class ProductsController < ApplicationController
  def index
    @shop = Shop.find(params[:shop_id])
    @products = Product.where(shop_id: params[:shop_id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @shop = Shop.find(params[:shop_id])
    @product = Product.new
  end

  def create
    @shop = Shop.find(params[:shop_id])
    @category = Category.find(params[:product][:category])
    @product = Product.new(product_params)
    @product.shop = @shop
    @product.category = @category
    if @product.save
      redirect_to shop_products_path(@shop)
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @category = Category.find(params[:product][:category])
    @product.category = @category
    @product.update(product_params)
    redirect_to shop_product_path(@product.shop, @product)
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to shop_products_path(@product.shop)
  end

  def add_to_cart
    unless current_user.carts.find_by(current_cart: true)
      cart = Cart.new
      cart.user = current_user
      cart.save
    else
      cart = current_user.carts.find_by(current_cart: true)
    end
    @product = Product.find(params[:id])
    cart_product = CartProduct.new(product_id: @product.id, product_price: @product.price, product_tax: @product.tax, quantity: 1)
    cart_product.cart = cart
    cart_product.save
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :ean, :tax, photos: [])
  end
end
