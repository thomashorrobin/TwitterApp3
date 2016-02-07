require 'test_helper'

class PartyAffiliationsControllerTest < ActionController::TestCase
  setup do
    @party_affiliation = party_affiliations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:party_affiliations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create party_affiliation" do
    assert_difference('PartyAffiliation.count') do
      post :create, party_affiliation: { partyAffiliation: @party_affiliation.partyAffiliation, partyColour: @party_affiliation.partyColour }
    end

    assert_redirected_to party_affiliation_path(assigns(:party_affiliation))
  end

  test "should show party_affiliation" do
    get :show, id: @party_affiliation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @party_affiliation
    assert_response :success
  end

  test "should update party_affiliation" do
    patch :update, id: @party_affiliation, party_affiliation: { partyAffiliation: @party_affiliation.partyAffiliation, partyColour: @party_affiliation.partyColour }
    assert_redirected_to party_affiliation_path(assigns(:party_affiliation))
  end

  test "should destroy party_affiliation" do
    assert_difference('PartyAffiliation.count', -1) do
      delete :destroy, id: @party_affiliation
    end

    assert_redirected_to party_affiliations_path
  end
end
