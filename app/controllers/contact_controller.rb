class ContactController < ApplicationController
  before_filter :authenticate_member!, :except => :public_contact

  def public_contact
    sender = { name: params[:nombre], email: params[:email], tel: params[:tel] }
    message = params[:text]
    Message.contact_mail(sender, message).deliver
    redirect_to root_es_path
  end

  def new
  end  

  def create
    message = params[:text]
    Message.suggestion(current_member.first_name, message).deliver
    redirect_to root_es_path
  end
end