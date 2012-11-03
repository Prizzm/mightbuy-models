class BusinessUrl < ActiveRecord::Base
  attr_accessible :domain, :business

  belongs_to :business

  validates_presence_of :domain

  def fqdn
    if domain =~ /^(http|https)/
      URI.parse(domain).host rescue domain
    else
      domain
    end
  end
end
