require 'test_helper'

class BankSubsidiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_subsidiary = bank_subsidiaries(:one)
  end

  test "should get index" do
    get bank_subsidiaries_url
    assert_response :success
  end

  test "should get new" do
    get new_bank_subsidiary_url
    assert_response :success
  end

  test "should create bank_subsidiary" do
    assert_difference('BankSubsidiary.count') do
      post bank_subsidiaries_url, params: { bank_subsidiary: { address: @bank_subsidiary.address, bank_id: @bank_subsidiary.bank_id } }
    end

    assert_redirected_to bank_subsidiary_url(BankSubsidiary.last)
  end

  test "should show bank_subsidiary" do
    get bank_subsidiary_url(@bank_subsidiary)
    assert_response :success
  end

  test "should get edit" do
    get edit_bank_subsidiary_url(@bank_subsidiary)
    assert_response :success
  end

  test "should update bank_subsidiary" do
    patch bank_subsidiary_url(@bank_subsidiary), params: { bank_subsidiary: { address: @bank_subsidiary.address, bank_id: @bank_subsidiary.bank_id } }
    assert_redirected_to bank_subsidiary_url(@bank_subsidiary)
  end

  test "should destroy bank_subsidiary" do
    assert_difference('BankSubsidiary.count', -1) do
      delete bank_subsidiary_url(@bank_subsidiary)
    end

    assert_redirected_to bank_subsidiaries_url
  end
end
