class PagesController < ApplicationController
  def about
  end
  def contact
    if params[:body] && params[:email] && params[:subject]
      UserMailer.contact_form(params[:email],params[:body],params[:subject]).deliver
  		flash[:notice]="Tu mensaje ha sido enviado y te responderemos a la brevedad"
      redirect_to "/locations/#{params[:location_id]}"
  	else
      flash.now[:notice]="Por favor rellena todos los campos"
    end
  end
  def faq
  end
end
