require "application_system_test_case"

class BankSubsidiariesTest < ApplicationSystemTestCase
  setup do
    @bank_subsidiary = bank_subsidiaries(:one)
  end

  test "visiting the index" do
    visit bank_subsidiaries_url
    assert_selector "h1", text: "Bank Subsidiaries"
  end

  test "creating a Bank subsidiary" do
    visit bank_subsidiaries_url
    click_on "New Bank Subsidiary"

    fill_in "Address", with: @bank_subsidiary.address
    fill_in "Bank", with: @bank_subsidiary.bank_id
    click_on "Create Bank subsidiary"

    assert_text "Bank subsidiary was successfully created"
    click_on "Back"
  end

  test "updating a Bank subsidiary" do
    visit bank_subsidiaries_url
    click_on "Edit", match: :first

    fill_in "Address", with: @bank_subsidiary.address
    fill_in "Bank", with: @bank_subsidiary.bank_id
    click_on "Update Bank subsidiary"

    assert_text "Bank subsidiary was successfully updated"
    click_on "Back"
  end

  test "destroying a Bank subsidiary" do
    visit bank_subsidiaries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bank subsidiary was successfully destroyed"
  end
end
