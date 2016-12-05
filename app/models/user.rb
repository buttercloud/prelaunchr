require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email, :send_referral_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'Shave<br>Cream',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'refer/cream-tooltip@2x.png')
    },
    {
      'count' => 10,
      'html' => 'Truman Handle<br>w/ Blade',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/truman@2x.png')
    },
    {
      'count' => 25,
      'html' => 'Winston<br>Shave Set',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/winston@2x.png')
    },
    {
      'count' => 50,
      'html' => 'One Year<br>Free Blades',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/blade-explain@2x.png')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    template = SendGrid::Template.new(SENDGRID_TEMPLATE_IDS[:welcome_email])
    recipient = SendGrid::Recipient.new(self.email)

    recipient.add_substitution(':how-am-i', "Happy")

    mailer = SendGrid::TemplateMailer.new(SENDGRID_CLIENT, template, Array(recipient))
    mailer.mail( {
      from: "feras@buttercloud.com",
      html: "<h1>Welcome to Prelaunchr</h1>",
      text: "Welcome to Prelaunchr",
      subject: "Test Email"
    }
   )
  end

  def send_referral_email
    if referrer.present?
      template = SendGrid::Template.new(SENDGRID_TEMPLATE_IDS[:referral_email])
      recipient = SendGrid::Recipient.new(referrer.email)

      recipient.add_substitution(':friend-email', self.email)
      recipient.add_substitution(':referral-count', referrer.referrals.count)

      mailer = SendGrid::TemplateMailer.new(SENDGRID_CLIENT, template, Array(recipient))
      mailer.mail( {
        from: "feras@buttercloud.com",
        html: "<h1>One of your friends just joined!</h1>",
        text: "One of your friends just joined!",
        subject: "Closer to your goal."
      }
     )
    end
  end
end
