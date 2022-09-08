module NavHelper
  def sign_out_link
    link_to t('sign_out'),
            destroy_user_session_path,
            method: :delete,
            data: { confirm: t('sign_out_confirm') }
  end

  def sign_up_link
    link_to t('sign_up'),
            new_user_registration_path
  end

  def sign_in_link
    link_to t('sign_in'),
            new_user_session_path
  end
end
