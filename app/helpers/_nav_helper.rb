module NavHelper
  def signout_link
    link_to t('sign_out'),
            destroy_user_session_path,
            method: :delete,
            data: { confirm: t('sign_out_confirm') }
  end
end
