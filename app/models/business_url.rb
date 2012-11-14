class BusinessUrl < ActiveRecord::Base
  attr_accessible :domain, :business

  belongs_to :business

  validates_presence_of :domain
  before_save :update_fqdn

  def update_fqdn
    self.fqdn = if domain =~ /^(http|https)/
      URI.parse(domain).host rescue domain
    else
      domain
    end
  end
end

