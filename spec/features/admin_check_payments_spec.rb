require "spec_helper"

feature "admin check payments" do
  scenario "admin can see all payments" do
    alice = Fabricate(:user)
    payment = Fabricate(:payment, amount: 999, user: alice, reference_id: "reference_id")
    admin_sign_in(Fabricate(:admin))
    visit(admin_payments_path)

    expect(page).to have_content("$9.99")
    expect(page).to have_content(alice.full_name)
    expect(page).to have_content(payment.reference_id)
  end

  scenario "user can not see the payment" do
    bob = Fabricate(:user)
    payment = Fabricate(:payment, amount: 999, user: bob, reference_id: "reference_id")
    user_sign_in(bob)
    visit(admin_payments_path)

    expect(page).to have_content("You have no right to do that!")
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content(payment.reference_id)
  end
end
