class OrdersController < ApplicationController
  def result
    if params[:SignatureValue]= Digest::MD5.hexdigest([Robokassa::MERCHANT_LOGIN,params[:OutSum],params[:InvId], Robokassa::MERCHANT_PASS_1].join(':'))
      render :text => "OK#{params[:InvId]}"
    else
      render :text => "FAIL"
    end
  end

  def success
    @order = Order.new(:price => params[:OutSum], :inv_id => params[:InvId])
    @order.save
  end

  def fail
    
  end
  def index
    @orders = Order.all

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
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(params[:order])
    redirect_to @order.get_pay
    #render :text => Robokassa.get_currencies.to_s
    # respond_to do |format|
    #   if @order.save
    #     format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #     format.json { render json: @order, status: :created, location: @order }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
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
