module DeviseHelper
  def devise_error_messages!
    if resource.errors.full_messages.any?
        flash.now[:info] = resource.errors.full_messages
    end
    return ''
  end
end
