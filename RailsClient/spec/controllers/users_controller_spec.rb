describe User do
  login_admin

  it "should have a current_user " do
    expect(subject.current_user).not_to eq(nil)
  end
end