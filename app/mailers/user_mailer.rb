class UserMailer < ActionMailer::Base
  default from: "policyoracle@gmail.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def mail_recap_week(email, markets)
    @markets = markets
    mail(:to => email, :subject => "PolicyOracle - Activity Report")
  end

  def newsletter(email, markets, tenant_obj)
    @markets = markets
    @tenant = tenant_obj
    mail(:to => email, :subject => "PolicyOracle - Newsletter")
  end
  
end
