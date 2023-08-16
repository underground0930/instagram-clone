class UserDecorator < ApplicationDecorator
  delegate_all

  def avatar_url(size = :origin)
    # rubocop:disable all
    return "https://placehold.jp/55/3d4070/ffffff/150x150.png?text=#{avatar.username}" unless avatar.present?
    # rubocop:enable all

    command = case size
              when :thumb
                { resize_to_fill: [48, 48] }
              when :lg
                { resize_to_fill: [100, 100] }
              else
                false
              end
    image = command ? avatar.variant(command).processed : avatar
    h.rails_storage_proxy_url(image, only_path: true)
  end
end
