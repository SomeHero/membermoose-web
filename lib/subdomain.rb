class Subdomain
  def self.matches?(request)
    binding.pry
    case request.subdomain
    when *Account::DISALLOWED_SUBDOMAINS
      false
    else
      true
    end
  end
end
