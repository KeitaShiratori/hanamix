module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    default_url = image_url "gravatar_default.png"
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{default_url}"
    size_str = size.to_s + "x" + size.to_s
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: size_str)
  end
  
end