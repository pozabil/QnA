module FeatureHelpers
  def login(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def stub_gist_request(gist_id, status)
    response_body = file_fixture("#{gist_id}.json").read.force_encoding("ASCII-8BIT")

    stub_request(:get, "https://api.github.com/gists/#{gist_id}").
      with(
        headers: {'Content-Type' => 'application/json'}
        ).
        to_return(status: status, body: response_body, headers: {'Content-Type' => 'application/json'})

    proxy.stub("https://api.github.com:443/gists/#{gist_id}", method: :get).and_return(
      headers: {
        'Access-Control-Allow-Origin'  => '*',
        'Content-Type' => 'application/json'
      },
      body: response_body,
      code: status
      )
  end

  def correct_text_for_expect(text)
    text.gsub(/(?!\n)([[:space:]])/, ' ').squeeze(' ').strip
  end
end
