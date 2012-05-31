class OrdersController < ApplicationController
  def result
    if params[:SignatureValue]= Digest::MD5.hexdigest([Robokassa::MERCHANT_LOGIN,params[:OutSum],params[:InvId], Robokassa::MERCHANT_PASS_1, "shp_currency=#{params[:shp_currency]}","shp_prc=#{params[:shp_prc]}", "shp_uid=#{params[:shp_uid]}"].join(':'))
      render :text => "OK#{params[:InvId]}"
    else
      render :text => "FAIL"
    end
  end

  def success
    @order = Order.new(:price => params[:shp_prc], :inv_id => params[:InvId], :user_id => params[:shp_uid], :currency => params[:shp_currency])
    @order.save
  end

  def fail
    
  end
  def index
    @orders = Order.all
    @user = User.find(@orders.user_id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end


  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  def new
    @order = Order.new
    @currencies = Robokassa.get_currencies
    @user_names = User.all.map{|u| [u.name, u.id]}
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(params[:order])
    if @order.valid?
      redirect_to @order.get_pay
    else
      redirect_to :back 
      flash[:notice] = "Invalid price field"
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
