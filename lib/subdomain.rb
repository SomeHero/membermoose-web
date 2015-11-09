class Subdomain
  def self.matches?(request)
    return false if !request.subdomain.present?

    case request.subdomain
    when *Account::DISALLOWED_SUBDOMAINS
      false
    else
      true
    end
  end
end
