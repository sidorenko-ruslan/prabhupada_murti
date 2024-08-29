class Api::PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def result
    signatureValue = params[:SignatureValue]
    order = Order.find(params[:InvId])
    order.payed!

    render plain: "OK #{order.id}"
  end

  def fail
    signatureValue = params[:SignatureValue]
    order = Order.find(params[:InvId])
    order.pay_error!
  end

  def success
    redirect_to "#{root_path}?operation_status=success"
  end

  private

  def password_2
    "afEYUPyst6MV9BZ76d9R"
  end
end
